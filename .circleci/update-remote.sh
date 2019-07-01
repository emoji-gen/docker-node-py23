#!/bin/sh

if [ -n "$(git --no-pager diff --raw)" ]; then
  echo 'The worktree is dirty.'

  git config user.name 'Emoji Generator'
  git config user.email 'ultimate.emoji.gen@gmail.com'
  git config remote.origin 'git@github.com:emoji-gen/docker-node-py23.git'

  git add .
  git commit -m 'chore(Dockerfile): update from images'
  git push origin master
fi
