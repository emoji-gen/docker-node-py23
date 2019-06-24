#!/bin/sh

NODE_VERSION=$(fgrep 'node:' Dockerfile | sed -E 's/^.*node\:([0-9\.]+).*$/\1/')
PYTHON2_VERSION=$(fgrep 'python:2' Dockerfile | sed -E 's/^.*python\:([0-9\.]+).*$/\1/')
PYTHON3_VERSION=$(fgrep 'python:3' Dockerfile | sed -E 's/^.*python\:([0-9\.]+).*$/\1/')
TAG_NAME="node$NODE_VERSION-py$PYTHON2_VERSION-py$PYTHON3_VERSION"

docker tag $DOCKER_OWNER/$DOCKER_IMAGE:latest $DOCKER_OWNER/$DOCKER_IMAGE:$TAG_NAME
docker push $DOCKER_OWNER/$DOCKER_IMAGE
docker push $DOCKER_OWNER/$DOCKER_IMAGE:$TAG_NAME
