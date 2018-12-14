#!/bin/sh

git --no-pager diff --raw

git commit -a -m 'chore(Dockerfile): update from images' --no-edit
