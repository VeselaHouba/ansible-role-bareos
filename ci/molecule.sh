#!/usr/bin/env bash
docker \
  run \
  --rm \
  -it \
  -v "$(pwd)":/tmp/$(basename "${PWD}") \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -w /tmp/$(basename "${PWD}") \
  veselahouba/molecule \
  molecule $@
