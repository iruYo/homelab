#!/bin/bash

LOCATION="$(dirname "$(readlink -f "$0")")"

docker run --rm -it \
    -v "$LOCATION/../ansible:/home/runner/ansible" \
    ioruy/ansible-runner:latest "$@"