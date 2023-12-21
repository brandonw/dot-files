#!/bin/bash

# initialize an index and an empty array of branches
i=1
declare -a branches

# list local branches in plain format and loop through them
while read -r branchname ; do
  branches[$i]="$branchname"
  printf "%2s    %s\n" $i $branchname
  ((i++))
done < <(git for-each-ref --format='%(refname:short)' refs/heads/)

printf "switch to: "
# read the user's selected integer
read selected_index
git switch "${branches[$selected_index]}"
