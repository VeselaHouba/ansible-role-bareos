#!/usr/bin/env bash
if [ $# -ne 1 ] ; then
  echo "usage $0 Full|Differential|Incremental"
  exit 1
fi
TYPE="$1"
DBVOLUMES=$(runuser -u postgres -- psql bareos -t -c "select count(*) from media where volumename like '${TYPE}-%';"|awk '{print $1}')
LASTVOLUME=$(runuser -u postgres -- psql bareos -t -c "select volumename from media where volumename like '${TYPE}-%' order by volumename desc limit 1;"|awk '{print $1}'|sed "s/${TYPE}-//g")
echo "Original number of volumes: ${DBVOLUMES}, last volume: ${TYPE}-${LASTVOLUME}"
(( DBVOLUMES+=1 ))
(( NEWVOLUME=LASTVOLUME+1 ))
echo "New number of volumes: ${DBVOLUMES}, new volume: ${TYPE}-${NEWVOLUME}"
echo "continue? [y/n]"
read -r cont
if [ "${cont}" != "y" ]; then
  echo "Cancelling"
  exit 1
fi
echo "Backing up config file /etc/bareos/bareos-dir.d/pool/${TYPE}.conf to /tmp/${TYPE}.conf"
cp -a /etc/bareos/bareos-dir.d/pool/"${TYPE}".conf /tmp/"${TYPE}".conf
sed -i "s/\(Maximum Volumes *= *\).*/\1$DBVOLUMES/" /etc/bareos/bareos-dir.d/pool/"${TYPE}".conf
echo "Reloading console"
echo "reload"|bconsole
echo "Labeling new volume"
echo "label pool=${TYPE} volume=${TYPE}-${NEWVOLUME} yes"|bconsole
