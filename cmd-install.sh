#!/usr/bin/env bash

if [ "$IN_DOCKER" == "" ]; then
  echo "cmd-install is meant to be run in docker container"

  if [ "$DOCKER_BIN" != "" ]; then
    cp "/bin/cmd-install" "$DOCKER_BIN/cmd-install"
  fi
  
  for cmd in "$@"; do
    cp "/bin/nix-env" "/bin/$cmd"

    if [ "$DOCKER_BIN" != "" ]; then
      cp "/bin/nix-env" "$DOCKER_BIN/$cmd"
    fi
  done
else
  docker run -ti \
    -v "$DOCKER_MOUNT:$DOCKER_MOUNT"
    -w "$PWD"
    -e "HOME=$HOME"
    "haskellworks/docker-nix:$(CIRCLE_BRANCH)" \
    $(basename "$0") "$@"
fi
