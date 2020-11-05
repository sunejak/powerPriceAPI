#!/bin/bash
#
# Get data for today at Frosta church
#
# https://www.yr.no/api/v0/locations/1-218408/celestialevents?

if [ -z "$1" ]; then
  echo "Provide a URL"
  exit 1
fi
#
data=$(curl -s $1)
if [ $? -ne 0 ] ; then
  echo "Could not access $1"
  exit 1;
fi
#
sunrise=$(echo $data | jq .times[1].sun.sunrise)
sunset=$(echo $data | jq .times[1].sun.sunset)

echo Sunrise: $sunrise
echo Sunset: $sunset

# window=$(date -d @$new_time)
