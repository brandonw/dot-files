-- Extra kubectl.nvim views. The plugin resolves every view (and its keymaps) with
-- require("kubectl.resources.<name>"), so preloading a module there adds a view.
-- These lean on plugin internals, so recheck them when bumping its version.

-- node labels/annotations shown as extra columns.
-- Clusters name the same thing differently, so each column lists candidate keys
-- in priority order; per cluster, it reads the first key that any node has.
local node_columns = {
  {
    header = "POOL",
    field = "labels",
    keys = { "hightouch.com/nodegroup", "kubernetes.azure.com/agentpool", "cloud.google.com/gke-nodepool" },
  },
  {
    header = "TYPE",
    field = "labels",
    keys = { "node.kubernetes.io/instance-type", "beta.kubernetes.io/instance-type" },
  },
}

-- the built-in nodes view plus node_columns
package.preload["kubectl.resources.nodes_wide"] = function()
  local nodes = require("kubectl.resources.nodes")
  local gvk = nodes.definition.gvk
  local headers = vim.deepcopy(nodes.definition.headers)
  for _, col in ipairs(node_columns) do
    table.insert(headers, col.header)
  end

  -- raw Node objects by name, plus the key each column reads in this cluster; re-read at
  -- most every 5s (the view redraws every 500ms)
  local by_name, col_keys, fetched_at = {}, {}, -math.huge
  local function raw_nodes()
    if vim.uv.now() - fetched_at > 5000 then
      fetched_at = vim.uv.now()
      local ok, json = pcall(require("kubectl.client").get_all, vim.json.encode({ gvk = gvk }))
      if ok then
        by_name = {}
        for _, n in ipairs(vim.json.decode(json, { luanil = { object = true, array = true } })) do
          by_name[n.metadata.name] = n
        end
        for _, col in ipairs(node_columns) do
          col_keys[col] = vim.iter(col.keys):find(function(key)
            return vim.iter(by_name):any(function(_, n)
              return (n.metadata[col.field] or {})[key] ~= nil
            end)
          end)
        end
      end
    end
    return by_name, col_keys
  end

  return require("kubectl.resources.base_resource").extend({
    resource = "nodes_wide",
    display_name = "NODES",
    ft = "k8s_nodes_wide",
    gvk = gvk,
    child_view = nodes.definition.child_view, -- <cr> lists the node's pods
    hints = nodes.definition.hints,
    headers = headers,
    -- rows arrive from the built-in node table; bolt the extra columns on. Empty cells
    -- get "-" because the plugin finds NAME by splitting the line on runs of spaces.
    processRow = function(rows)
      local raw, keys = raw_nodes()
      for _, row in ipairs(rows) do
        local n = raw[row.name]
        for _, col in ipairs(node_columns) do
          local value = n and keys[col] and (n.metadata[col.field] or {})[keys[col]]
          row[col.header:lower()] = value or "-"
        end
      end
      return rows
    end,
  })
end

-- reuse the built-in node view's drain/cordon/uncordon/shell keymaps
package.preload["kubectl.resources.nodes_wide.mappings"] = function()
  return require("kubectl.resources.nodes.mappings")
end
