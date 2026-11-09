-- Extra columns for kubectl.nvim's built-in views. These lean on plugin internals, so
-- recheck them when bumping its version.

-- Node object fields shown as extra columns. Each column reads keys under the `field`
-- path. Clusters name the same thing differently, so each column lists candidate keys
-- in priority order; per cluster, it reads the first key that any node has.
local node_columns = {
  {
    header = "POOL",
    field = { "metadata", "labels" },
    keys = { "hightouch.com/nodegroup", "kubernetes.azure.com/agentpool", "cloud.google.com/gke-nodepool" },
  },
  {
    header = "TYPE",
    field = { "metadata", "labels" },
    keys = { "node.kubernetes.io/instance-type", "beta.kubernetes.io/instance-type" },
  },
  {
    header = "KERNEL",
    field = { "status", "nodeInfo" },
    keys = { "kernelVersion" },
  },
}

-- the table at path `field` in Node `n`, or {}
local function field_of(n, field)
  return vim.tbl_get(n, unpack(field)) or {}
end

-- Extend the built-in nodes view in place with node_columns. Every code path (reload,
-- back, :Kubectl nodes, drain) resolves the view by its buffer name with
-- require("kubectl.resources.nodes") and passes that module's `definition` to the
-- builder by reference, so changing it here changes the view everywhere. Load this
-- after setup() and before the first nodes View().
local nodes = require("kubectl.resources.nodes")
local definition = nodes.definition
for _, col in ipairs(node_columns) do
  table.insert(definition.headers, col.header)
end

-- raw Node objects by name, plus the key each column reads in this cluster; re-read at
-- most every 5s (the view redraws every 500ms)
local by_name, col_keys, fetched_at = {}, {}, -math.huge
local function raw_nodes()
  if vim.uv.now() - fetched_at > 5000 then
    fetched_at = vim.uv.now()
    local ok, json = pcall(require("kubectl.client").get_all, vim.json.encode({ gvk = definition.gvk }))
    if ok then
      by_name = {}
      for _, n in ipairs(vim.json.decode(json, { luanil = { object = true, array = true } })) do
        by_name[n.metadata.name] = n
      end
      for _, col in ipairs(node_columns) do
        col_keys[col] = vim.iter(col.keys):find(function(key)
          return vim.iter(by_name):any(function(_, n)
            return field_of(n, col.field)[key] ~= nil
          end)
        end)
      end
    end
  end
  return by_name, col_keys
end

-- rows arrive from the built-in node table; bolt the extra columns on. Empty cells get
-- "-" because the plugin finds NAME by splitting the line on runs of spaces.
definition.processRow = function(rows)
  local raw, keys = raw_nodes()
  for _, row in ipairs(rows) do
    local n = raw[row.name]
    for _, col in ipairs(node_columns) do
      local value = n and keys[col] and field_of(n, col.field)[keys[col]]
      row[col.header:lower()] = value or "-"
    end
  end
  return rows
end
