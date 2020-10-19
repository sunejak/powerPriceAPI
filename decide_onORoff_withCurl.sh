#!/bin/bash
#
if [ -z "$1" ]; then
  echo "Provide a time delta in hours"
  exit 1
fi
hours=$1
delta=$((hours * 3600))
#
if [ -z "$2" ]; then
  echo "Provide a URL"
  exit 1
fi
URL=$2
#
data=$( curl -fsS -w '%{http_code}' ${URL})
if [ $? -ne 0 ] ; then
  echo "Could not access: ${URL}"
  exit 1;
fi

peaktime=$( echo ${data} | cut -f1 -d ' ')
starttime=$(( peaktime - delta ))
stoptime=$(( peaktime + delta ))
#
now=$(date "+%s")
#
echo Time $now window $starttime $stoptime
# gpio mode 1 output
#
if [ $now -gt $starttime ] && [ $now -lt $stoptime ]; then
  echo Inside window $(date)
#  gpio write 1 1
  else
  echo Outside window $(date)
#  gpio write 1 0
fi
