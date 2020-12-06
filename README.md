# powerPriceAPI

On your server, process the input once a day and update the webserver, using crontab:

40 14 * * *      cd /home/xyz ; ./create_offpeak_time.sh  market-$(date -I).json >> /var/www/html/market.log

On your server, get sunrise and sunset from yr.no, NB: Find your location ID first.

0 12 * * 1     cd /home/xyz ; ./get_sunrise_sunset.sh https://www.yr.no/api/v0/locations/1-218408/celestialevents >> /var/www/html/suntime.log

On your raspberry pi, fetch the data from the webserver every 5 minutes, using crontab:

*/5 * * * * cd /home/xyz ; ./decide_onORoff_withCurl.sh 1.5 http:/192.168.1.123/market.log >> stdout.log

*/5 * * * * cd /home/xyz ; ./decide_daylight_withCurl.sh http:/192.168.1.23/suntime.log >> stdout.log
