#!/bin/sh

if [ -n "$(git --no-pager diff --raw)" ]; then
  echo 'The worktree is dirty.'

  git config user.name 'Emoji Generator'
  git config user.email 'ultimate.emoji.gen@gmail.com'

  export GIT_SSH_COMMAND='ssh -o StrictHostKeyChecking=no'
  git stash -u
  git checkout master
  git pull origin master
  git stash pop
  git status
  git commit -a -m 'chore(Dockerfile): update images'
  git status
  git push origin master
fi
