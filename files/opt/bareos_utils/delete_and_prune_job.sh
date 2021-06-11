#!/usr/bin/env bash
if [ $# -ne 1 ] ; then
  echo "Usage $0 JOBID"
  exit 1
fi
JOBID="${1}"
MEDIAIDS=$(runuser -u postgres -- psql bareos -t -c "select distinct mediaid from jobmedia where jobid=${JOBID} order by mediaid asc;")
VOLUMES=""
for MEDIAID in ${MEDIAIDS}; do
  VOLUMENAME=$(runuser -u postgres -- psql bareos -t -c "select volumename from media where mediaid=${MEDIAID};"|awk '{print $1}')
  VOLUMES="${VOLUMES} ${VOLUMENAME}"
done
echo "Job ${JOBID} is using following volumes"
for VOLUME in ${VOLUMES}; do
  echo "${VOLUME}"
done
echo "Delete job? [y/n]"
read -r ans
if [ "${ans}" = 'y' ]; then
  echo "Deleting job from catalog, this can take long time"
  echo "delete jobid=${JOBID} yes"|bconsole
  for VOLUME in ${VOLUMES}; do
    echo "prune volume=${VOLUME} yes"|bconsole
  done
fi
