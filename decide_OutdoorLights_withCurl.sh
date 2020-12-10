#!/bin/bash
#
# ./decide_OutdoorLights_withCurl.sh http://192.168.1.23/suntime.log "15:00 today" "01:00 tomorrow"
#
# 00:00 -> on until 1:00 -> off until 5:00 -> on until sunrise -> off until sunset -> on until 23:59
#
if [ -z "$1" ]; then
  echo "Provide a URL for sunset data"
  exit 1
fi
URL=$1
#
if [ -z "$2" ]; then
  echo "Provide a begin time, when lights can turn on"
  exit 1
fi
onMorningTime=$(date --date="$2" "+%s");    # 5:00
#
if [ -z "$3" ]; then
  echo "Provide an end time, when lights must turn off"
  exit 1
fi
offEveningTime=$(date --date="$3" "+%s");  # 1:00
#
midnightToday=$(date -d "0:00 today" "+%s")
midnightTomorrow=$(date -d "0:00 tomorrow" "+%s")

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
turnOn=false;

# keep light on from midnight until given time
if [  $now -gt $midnightToday ] && [ $now -lt $offEveningTime ] ; then
  turnOn=true;
  fi
# turn on light in the morning until sunrise
if [  $now -gt $onMorningTime ] && [ $now -lt $sunrisetime ] ; then
  turnOn=true;
  fi
# turn on light at sunset
if [  $now -gt $sunsettime ]  ; then
  turnOn=true;
  fi

if [  $turnOn ] ; then
      gpio write 5 1
else
      gpio write 5 0
fi
