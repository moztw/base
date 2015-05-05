#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
HOSTNAME=$(hostname -f)
DATE=$(date +"%Y-%m-%d %T")
LOGFILE=/tmp/file_log.log
FCHECK=/usr/sbin/fcheck
FCHECKCONF=/etc/fcheck/fcheck.cfg

# Only let root run this script
if [ $EUID -ne 0 ]; then
  echo "You must run this script as root (try sudo)" 1>&2
  exit 1
fi

$FCHECK -ar $FCHECKCONF > $LOGFILE
$FCHECK -arc $FCHECKCONF > /dev/null

FCHECKSTATUS=$(tail -n 2 $LOGFILE | head -n 1)
if [ "$FCHECKSTATUS" = "STATUS:passed..." ]; then
  echo "" | mail -s "($DATE) $HOSTNAME File Change Info - None EOM" admin@mail.moztw.org
  exit 1
else
  mail -s "($DATE) $HOSTNAME File Change Info" admin@mail.moztw.org < $LOGFILE
  rm -rf $LOGFILE
  exit 0
fi
