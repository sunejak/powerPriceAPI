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
  echo "Provide a data input file"
  exit 1
fi
filename=$2
#
peaktime=$( grep $(date -I) $filename | cut -f1 -d ' ')
starttime=$(( peaktime - delta ))
stoptime=$(( peaktime + delta ))
#
now=$(date "+%s")
#
echo Time $now window $starttime $stoptime
#
if [ $now -gt $starttime ] && [ $now -lt $stoptime ]; then
  echo Inside window $(date)
  else
  echo Outside window $(date)
fi
