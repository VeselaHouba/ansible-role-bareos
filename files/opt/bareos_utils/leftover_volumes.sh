#!/usr/bin/env bash
VOLUME_TYPE=Full
VOLUME_PATH=/var/lib/bareos/storage
VOLUMESDB=$(runuser -u postgres -- psql bareos -t -c "select volumename from media where volumename like '${VOLUME_TYPE}-%' order by volumename asc")
VOLUMESFS=$(find "${VOLUME_PATH}" -mindepth 1 -maxdepth 1 -name "${VOLUME_TYPE}-*" -type f -printf '%P\n' | sort)
for volumefs in ${VOLUMESFS}; do
  if [[ ! " ${VOLUMESDB[*]} " =~ ${volumefs} ]]; then
    echo "${volumefs} exists on disk, but not found in DB"
  fi
done
echo "Finished"
