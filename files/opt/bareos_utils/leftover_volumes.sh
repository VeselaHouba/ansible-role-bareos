#!/usr/bin/env bash
VOLUMESDB=$(runuser -u postgres -- psql bareos -t -c "select volumename from media where volumename like 'Full-%' order by volumename asc")
VOLUMESFS=$(find /var/lib/bareos/storage/ -name "Full-*" -mindepth 1 -maxdepth 1 -type f -printf '%P\n' | sort)
for volumefs in ${VOLUMESFS}; do
  if [[ ! " ${VOLUMESDB[*]} " =~ ${volumefs} ]]; then
    echo "${volumefs} exists on disk, but not found in DB"
  fi
done
echo "Finished"
