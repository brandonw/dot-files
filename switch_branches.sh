#!/bin/bash

# initialize an index and an empty array of branches
i=1
declare -a branches

# prioritize main/master first
while read -r branchname ; do
  branches[$i]="$branchname"
  printf "%2s    %s\n" $i $branchname
  ((i++))
done < <(git for-each-ref --format='%(refname:short)' refs/heads/ | rg '^(main|master)$')

# then list non-deploy branches
while read -r branchname ; do
  branches[$i]="$branchname"
  printf "%2s    %s\n" $i $branchname
  ((i++))
done < <(git for-each-ref --format='%(refname:short)' refs/heads/ | rg -v '^(main|master|deploy/.+)$')

# then list deploy branches
while read -r branchname ; do
  branches[$i]="$branchname"
  printf "%2s    %s\n" $i $branchname
  ((i++))
done < <(git for-each-ref --format='%(refname:short)' refs/heads/ | rg '^(deploy/.+)$')

printf "switch to: "
# read the user's selected integer
read selected_index
git switch "${branches[$selected_index]}"
