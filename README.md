# powerPriceAPI

On your server, process the input and update the webserver, using crontab:

40 14 * * *      cd /home/xyz ; ./create_offpeak_time.sh  market-$(date -I).json >> /var/www/html/market.log

On your raspberry pi, fetch the data forom the webserver, using crontab:

*/5 * * * * cd /home/xyz ; ./decide_onORoff_withCurl.sh 2 http:/192.168.1.123/market.log >> stdout.log
