#!/bin/sh

TMP_DIR=/tmp

PLATFORM=stretch
NODE_TAGS_URL='https://registry.hub.docker.com/v1/repositories/library/node/tags'
NODE_TAGS_PATH="$TMP_DIR/node.txt"
PYTHON_TAGS_URL='https://registry.hub.docker.com/v1/repositories/library/python/tags'
PYTHON_TAGS_PATH="$TMP_DIR/python_tags.txt"

# -----------------------------------------------------------------------------

printf "Finding docker tags ."
wget -O - "$NODE_TAGS_URL" -qq | jq -r '.[].name' > "$NODE_TAGS_PATH"
printf "."
wget -O - "$PYTHON_TAGS_URL" -qq | jq -r '.[].name' > "$PYTHON_TAGS_PATH"
printf ".\n"

# -----------------------------------------------------------------------------

printf "\n"
echo "Updating ..."

NODE_VERSION=$(fgrep 'node:' Dockerfile | sed -E 's/^.*node\:([0-9\.]+).*$/\1/')
PYTHON2_VERSION=$(fgrep 'python:2' Dockerfile | sed -E 's/^.*python\:([0-9\.]+).*$/\1/')
PYTHON3_VERSION=$(fgrep 'python:3' Dockerfile | sed -E 's/^.*python\:([0-9\.]+).*$/\1/')

NODE_LATEST_VERSION=$(
  grep -E "[0-9]+\.[0-9]+\.[0-9]+-$PLATFORM" < "$NODE_TAGS_PATH" \
    | cut -f 1 -d '-' \
    | sort -t. -k 1,1nr -k 2,2nr -k 3,3nr \
    | head -1
)
PYTHON2_LATEST_VERSION=$(
  grep -E "2\.[0-9]+\.[0-9]+-$PLATFORM" < "$PYTHON_TAGS_PATH" \
    | cut -f 1 -d '-' \
    | sort -t. -k 1,1nr -k 2,2nr -k 3,3nr \
    | head -1
)
PYTHON3_LATEST_VERSION=$(
  grep -E "3\.[0-9]+\.[0-9]+-$PLATFORM" < "$PYTHON_TAGS_PATH" \
    | cut -f 1 -d '-' \
    | sort -t. -k 1,1nr -k 2,2nr -k 3,3nr \
    | head -1
)

echo "\tNode v$NODE_VERSION -> v$NODE_LATEST_VERSION"
echo "\tPython v$PYTHON2_VERSION -> v$PYTHON2_LATEST_VERSION"
echo "\tPython v$PYTHON3_VERSION -> v$PYTHON3_LATEST_VERSION"

sed -i -E "s/FROM node:([0-9]+\.[0-9]+\.[0-9]+)/FROM node:$NODE_LATEST_VERSION/" Dockerfile
sed -i -E "s/FROM python:(2\.[0-9]+\.[0-9]+)/FROM python:$PYTHON2_LATEST_VERSION/" Dockerfile
sed -i -E "s/FROM python:(3\.[0-9]+\.[0-9]+)/FROM python:$PYTHON3_LATEST_VERSION/" Dockerfile

# -----------------------------------------------------------------------------

printf "\n\e[32msuccess\e[39m\n"
