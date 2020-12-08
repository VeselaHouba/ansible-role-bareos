#!/usr/bin/env bash
JOBID=$(runuser -u postgres -- psql bareos -t -c "select jobid from job where level like 'F' and jobstatus like 'T' and job not like 'BackupCatalog%' order by endtime asc limit 1;")
echo "oldest jobid: ${JOBID}"
MEDIAIDS=$(runuser -u postgres -- psql bareos -t -c "select distinct mediaid from jobmedia where jobid=${JOBID} order by mediaid asc;")
for MEDIAID in ${MEDIAIDS}; do
  #echo "${MEDIAID}"
  VOLUMENAME=$(runuser -u postgres -- psql bareos -t -c "select volumename from media where mediaid=${MEDIAID};"|awk '{print $1}')
  echo "using volume: ${VOLUMENAME}"
done
echo "You can now use purge command in bconsole for the mediaid. Beware that other jobs using the same volumes will be deleted too!"
