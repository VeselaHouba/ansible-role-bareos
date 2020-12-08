#!/usr/bin/env sh
set -e

cat ./ci/gitlab-ci.yml.base > .gitlab-ci-molecule.yml

for SCENARIO in $(ls molecule)
do
  echo "Generating job for ${SCENARIO} ..."
  sed "s/SCENARIO/${SCENARIO}/g" ./ci/gitlab-ci.yml.job >> .gitlab-ci-molecule.yml
done
