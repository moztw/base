#!/bin/sh
DATE=`date +"%Y-%m-%d %T"`

if [ $USER != root ]; then
  echo 'You must run this script as root (try sudo)'
  exit 0
fi
      

if [ -e /tmp/file_log.log ]; then
  cat /tmp/file_log.log | mail -s "($DATE) MozTW.org File Change Info" admin@mail.moztw.org
  rm -rf /tmp/file_log.log
  exit 1
else
  echo "" | mail -s "($DATE) MozTW.org File Change Info - None EOM" admin@mail.moztw.org
  exit 0
fi
 

