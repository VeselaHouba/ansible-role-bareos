#!/usr/bin/env bash
echo "Will drop last 100 failed/cancelled jobs and prune their volumes."
echo "You have 10s to cancel with ctrl+c"
sleep 10

LOGFILE=/var/log/bareos_prune_failed.log
JOBIDS=$(runuser -u postgres -- psql bareos -t -c "select jobid from job where job not like 'BackupCatalog%' and (jobstatus like 'A' or jobstatus like 'f') order by jobid desc limit 10;")
for JOBID in ${JOBIDS}; do
  MEDIAIDS=$(runuser -u postgres -- psql bareos -t -c "select distinct mediaid from jobmedia where jobid=${JOBID} order by mediaid asc;")
  VOLUMES=""
  for MEDIAID in ${MEDIAIDS}; do
    VOLUMENAME=$(runuser -u postgres -- psql bareos -t -c "select volumename from media where mediaid=${MEDIAID};"|awk '{print $1}')
    VOLUMES="${VOLUMES} ${VOLUMENAME}"
  done
  echo "Job ${JOBID} is using following volumes" | tee -a "${LOGFILE}"
  for VOLUME in ${VOLUMES}; do
    echo "${VOLUME}"
  done
  echo "Deleting job from catalog, this can take long time" | tee -a "${LOGFILE}"
  echo "delete jobid=${JOBID} yes"|bconsole &>> "${LOGFILE}"
  for VOLUME in ${VOLUMES}; do
    echo "prune volume=${VOLUME} yes"|bconsole &>> "${LOGFILE}"
  done
done
echo "bconsole output in ${LOGFILE}"
