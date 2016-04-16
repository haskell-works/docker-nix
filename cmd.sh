#!/usr/bin/env bash

if [ "$IN_DOCKER" == 1 ]; then
  cmd=$(basename "$0")
  old_cmd=$(which $cmd)
  source /root/.nix-profile/etc/profile.d/nix.sh
  new_cmd=$(which $cmd)

  if [ "$old_cmd" == "$new_cmd" ]; then
    echo "$cmd is not installed in nix"
    exit 1
  fi

  $(basename "$0") "$@"
else
  docker run -ti \
    -v "$DOCKER_MOUNT:$DOCKER_MOUNT"
    -w "$PWD"
    -e "HOME=$HOME"
    "haskellworks/docker-nix:$(CIRCLE_BRANCH)" \
    $(basename "$0") "$@"
fi
