#!/bin/bash

LOCATION="$(dirname "$(readlink -f "$0")")"

docker build -t ioruy/ansible-runner:latest "$LOCATION"