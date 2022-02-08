#!/usr/bin/env bash
docker \
  run \
  --rm \
  -ti \
  -v "$(pwd):/tmp/$(basename "${PWD}")" \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -w "/tmp/$(basename "${PWD}")" \
  -e HCLOUD_TOKEN \
  -e MOLECULE_IMAGE \
  -e MOLECULE_NO_LOG=false \
  -e REF=manual \
  -e REPO_NAME="$(basename "${PWD}")" \
  veselahouba/molecule bash -c "
  shellcheck_wrapper && \
  flake8 && \
  yamllint . && \
  ansible-lint && \
  cp -a ./ /tmp/role/ && \
  cd /tmp/role && \
  curl https://raw.githubusercontent.com/VeselaHouba/molecule/master/molecule-docker/pull_files.sh > ci/pull_files.sh && \
  bash ci/pull_files.sh && \
  molecule ${*}"
