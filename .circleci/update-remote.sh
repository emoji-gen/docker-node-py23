#!/bin/sh

if [ -n "$(git --no-pager diff --raw)" ]; then
  echo 'The worktree is dirty.'

  git config user.name 'Emoji Generator'
  git config user.email 'ultimate.emoji.gen@gmail.com'

  git stash -u
  git checkout master
  git pull origin master
  git stash pop
  git add .
  git commit -m 'chore(Dockerfile): update from images'
  GIT_SSH_COMMAND='ssh -o StrictHostKeyChecking=no' git push origin master
fi
