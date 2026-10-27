#!/usr/bin/env bash

# git review <branch> [base]: base defaults to the PR's base branch on GitHub
set -uo pipefail

if [ $# -lt 1 ] || [ $# -gt 2 ]; then
  echo 'usage: git review <branch> [base]' >&2
  exit 1
fi

if [ -n "$(git status --porcelain)" ]; then
  echo 'working tree not clean; stash or discard these first:' >&2
  git status --short >&2
  exit 1
fi

b=$1
base=${2:-$(gh pr view "$b" --json baseRefName -q .baseRefName)} || {
  echo "no PR found for $b; pass the base branch explicitly" >&2
  exit 1
}

git fetch origin \
  "+refs/heads/master:refs/remotes/origin/master" \
  "+refs/heads/$b:refs/worktree/review" \
  "+refs/heads/$base:refs/worktree/review-base" &&
  git switch --detach refs/worktree/review || exit 1

from=$(git merge-base refs/worktree/review-base HEAD) || {
  echo "no merge base between $base and $b" >&2
  exit 1
}
to=$(git rev-parse HEAD)

echo "reviewing $b against $base"
git log --oneline "$from..$to"
echo
echo "from: $from"
echo "to:   $to"
