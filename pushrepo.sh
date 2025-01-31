#!/usr/bin/env bash
#
# pushrepo.sh
#
# Stage, commit (if needed), and push the current Git repository
# from any subdirectory. Moves to top-level, checks remote, etc.

set -e

# 1) Confirm in a Git repo
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  echo "Not inside a Git repository."
  exit 1
fi

# 2) Move to top-level
TOP_LEVEL="$(git rev-parse --show-toplevel)"
cd "$TOP_LEVEL"

# 3) Stage all changes
echo "Staging all changes with 'git add .'"
git add .

# 4) Check if there's anything staged
CHANGES="$(git diff --cached --name-only)"
if [ -n "$CHANGES" ]; then
  echo "You have changes staged for commit:"
  echo "$CHANGES"
  echo
  read -rp "Enter commit message (leave empty for default): " COMMIT_MSG
  if [ -z "$COMMIT_MSG" ]; then
    COMMIT_MSG="Auto-commit by pushrepo.sh"
  fi
  git commit -m "$COMMIT_MSG"
else
  echo "No staged changes to commit. Proceeding to push..."
fi

# 5) Ensure we have remote 'origin'
HAS_ORIGIN="$(git remote | grep ^origin || true)"
if [ -z "$HAS_ORIGIN" ]; then
  echo "No remote 'origin' found."
  read -rp "Would you like to add one now? (y/n) " SETREM
  if [[ "$SETREM" =~ ^[Yy]$ ]]; then
    read -rp "Enter remote URL: " REMOTE_URL
    if [ -n "$REMOTE_URL" ]; then
      git remote add origin "$REMOTE_URL"
      echo "Remote origin set to $REMOTE_URL"
    else
      echo "No URL provided, skipping..."
    fi
  fi
fi

# 6) Push
CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
UPSTREAM_EXISTS="$(git rev-parse --symbolic-full-name --abbrev-ref @{u} 2>/dev/null || true)"

if [ -z "$UPSTREAM_EXISTS" ]; then
  echo "No upstream tracking for branch '$CURRENT_BRANCH'. Setting upstream to origin/$CURRENT_BRANCH..."
  git push -u origin "$CURRENT_BRANCH"
else
  git push
fi

echo "Push complete."
