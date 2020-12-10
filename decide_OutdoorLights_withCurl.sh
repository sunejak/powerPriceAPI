#!/bin/bash
#
# ./decide_OutdoorLights_withCurl.sh http://192.168.1.23/suntime.log "15:00 today" "01:00 tomorrow"
#
if [ -z "$1" ]; then
  echo "Provide a URL for sunset data"
  exit 1
fi
URL=$1

if [ -z "$2" ]; then
  echo "Provide a begin time, when lights can turn on"
  exit 1
fi
begintime=$(date --date="$2" "+%s");

if [ -z "$3" ]; then
  echo "Provide an end time, when lights must turn off"
  exit 1
fi
endtime=$(date --date="$3" "+%s");

# fetch sunrise and sunset times, use RAM disk on pi.

tmpfile=/mnt/ramdisk/sun.tmp
tmpfile=sun.tmp

data=$( curl -fsS -w '%{http_code}' ${URL} > ${tmpfile} )
if [ $? -ne 0 ] ; then
  echo "Could not access: ${URL}"
  exit 1;
fi

today=$(grep $(date -I) ${tmpfile})
if [ $? -ne 0 ] ; then
  echo "Could not find data for today"
  exit 1;
fi

sunsettime=$(echo $today | cut -d ' ' -f4)
sunrisetime=$(echo $today | cut -d ' ' -f1)
#
now=$(date "+%s")
#
# echo Daylight window from: $(date --date=@$sunrisetime) to:  $(date --date=@$sunsettime)
# echo On window from: $(date --date=@$begintime) to:  $(date --date=@$endtime)
gpio mode 5 output

if [  $now -gt $begintime ] && [ $now -lt $endtime ] ; then
#
      if [ $now -gt $sunsettime ] ; then
        echo Inside window $(date) Sunset from: $(date --date=@$sunsettime)  on until: $(date --date=@$endtime)
      gpio write 5 1
      fi
else
# outside window, turn off
gpio write 5 0
fi
