#!/bin/bash
#
if [ -z "$1" ]; then
  echo "Provide a data input file"
  exit 1
fi
#
# Get the location for data
#
location=$(jq .data.Rows[0].Columns[3].Name $1 | tr -d '"' )
#
if [ $location != "Tr.heim" ]; then
  echo "No data for Trondheim" $location
  exit 1
fi
#
# Get the date for the data
#
today=$(jq .data.Rows[0].StartTime $1 | tr -d '"' ) 
#
# Then pick out the value pr hour
#
dataset=$(for i in {0..23}; do echo $(jq .data.Rows[$i].Columns[3].Value $1) $i ; done )
#
# find lowest price hour
#
# low_price_hour=$(for i in {0..23}; do echo $(jq .data.Rows[$i].Columns[3].Value $1) $i ; done | tr -d '"' | sort -n | head -1 | cut -d' '  -f2)
#
# find highest price hour
#
high_price_hour=$(for i in {0..23}; do echo $(jq .data.Rows[$i].Columns[3].Value $1) $i ; done | tr -d '"' | sort -n | tail -1 | cut -d' '  -f2)
high_price=$(jq .data.Rows[$high_price_hour].Columns[3].Value $1 | tr -d '"')
#
# calculate delta in seconds
#
delta=$((high_price_hour * 3600))
#
# calculate time window  since 1970
#
mytime=$(date -d $today '+%s')
new_time=$(( mytime + delta ))
#
window=$(date -d @$new_time)
#
#
echo $new_time $window $location $high_price_hour $high_price $today

