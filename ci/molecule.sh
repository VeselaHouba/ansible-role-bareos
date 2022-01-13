#!/usr/bin/env bash
docker \
  run \
  --rm \
  -ti \
  -v "$(pwd):/tmp/$(basename "${PWD}")" \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -w "/tmp/$(basename "${PWD}")" \
  -e MOLECULE_IMAGE_SERVER \
  -e MOLECULE_IMAGE_CLIENT \
  -e MOLECULE_NO_LOG=false \
  veselahouba/molecule bash -c "
  shellcheck_wrapper && \
  flake8 && \
  yamllint . && \
  ansible-lint && \
  molecule ${*}"
