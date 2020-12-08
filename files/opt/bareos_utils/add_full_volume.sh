#!/usr/bin/env bash
DBVOLUMES=$(runuser -u postgres -- psql bareos -t -c "select count(*) from media where volumename like 'Full-%';"|awk '{print $1}')
LASTVOLUME=$(runuser -u postgres -- psql bareos -t -c "select volumename from media where volumename like 'Full-%' order by volumename desc limit 1;"|awk '{print $1}'|sed 's/Full-//g')
echo "Original number of volumes: ${DBVOLUMES}, last volume: Full-${LASTVOLUME}"
let "DBVOLUMES+=1"
let "NEWVOLUME=LASTVOLUME+1"
echo "New number of volumes: ${DBVOLUMES}, new volume: Full-${NEWVOLUME}"
echo "continue? [y/n]"
read cont
if [ "${cont}" != "y" ]; then
  echo "Cancelling"
  exit 1
fi
echo "Backing up config file /etc/bareos/bareos-dir.d/pool/Full.conf to /tmp/Full.conf"
cp -a /etc/bareos/bareos-dir.d/pool/Full.conf /tmp/Full.conf
sed -i "s/\(Maximum Volumes *= *\).*/\1$DBVOLUMES/" /etc/bareos/bareos-dir.d/pool/Full.conf
echo "Reloading console"
echo "reload"|bconsole
echo "Labeling new volume"
echo "label pool=Full volume=Full-${NEWVOLUME} yes"|bconsole
