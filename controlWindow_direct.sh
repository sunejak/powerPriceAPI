#!/bin/bash
#
# WindowMaster control script
#
# using pin 28 and pin 29
#
if [ -z "$1" ]; then
  echo "Provide a URL "
  exit 1
fi
#
gpio mode 28 out
gpio mode 29 out
#
gpio write 28 0
gpio write 29 0
#
echo Valid commands are: open close reset
# 
while true
do
read variable
case $variable in
open)
  gpio write 28 1
  gpio write 29 0
;;
close)
  gpio write 28 0
  gpio write 29 1
;;
reset)
  gpio write 28 0
  gpio write 29 0
;;
*)
  exit 0;
;;
esac
done
