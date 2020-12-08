#!/usr/bin/env bash
docker \
  run \
  --rm \
  -it \
  -v "$(pwd):/tmp/veselahouba.bareos" \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -w "/tmp/veselahouba.bareos" \
  -e MOLECULE_DISTRO_SERVER \
  -e MOLECULE_DISTRO_CLIENT \
  -e MOLECULE_NO_LOG=false \
  veselahouba/molecule:latest \
  molecule "${@}"
