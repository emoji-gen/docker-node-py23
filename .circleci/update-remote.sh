#!/bin/sh

if [ -n "$(git --no-pager diff --raw)" ]; then
  echo 'The worktree is dirty.'
  git add .
  git commit -m 'chore(Dockerfile): update from images'
fi
