#!/bin/sh

git diff --raw

git commit -a -m 'chore(Dockerfile): update from images' --no-edit
