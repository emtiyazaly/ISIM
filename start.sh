#! /bin/bash
##############################################################################
# This script is not officially supported by IBM Performance test. 
# Author: Imtiaz Ali
# This script is used to restart stuck ISIM Application
# Assign your ISIM Messaging server name to veriable <ISIMMSGServerName>
# Assign your ISIM Application server name to veriable <ISIMAPPServerName>
# Assign your WebSphere Profile name to veriable <Profile_Name>
##############################################################################
clear && printf '\e[3J'
myTimeStamp=$(date +"%Y-%m-%d %H-%M-%S")
ClientName=$(who | awk '{print $1}')
ClientIP=$(who | awk '{print $5}')
ISIMMSGServerName="<ITIM-MSG-PRI>"
ISIMAPPServerName="<ITIM-APP-PRI>"
ProfileName="<ProfileName>"
echo " ==================================================================== "
echo "					Please Wait..."
echo " ==================================================================== "
kill -9 $(ps aux | grep '[j]ava' | awk '{print $2}')
sleep 5
echo " ======================== Starting NodeAgent on this Managed Node! ======================== "
/opt/IBM/WebSphere/AppServer/profiles/<Profile_Name>/bin/startNode.sh
echo " ======================== Done with Starting NodeAgent ======================== "
echo ""
sleep 2
echo " ======================== Starting Messaging Server ======================== "
/opt/IBM/WebSphere/AppServer/profiles/${ProfileName}/bin/startServer.sh ${ISIMMSGServerName}
echo " ======================== Done with Starting Messaging Server Call ======================== "
sleep 2
echo ""
echo " ======================== Starting Application Server ======================== "
/opt/IBM/WebSphere/AppServer/profiles/${ProfileName}/bin/startServer.sh ${ISIMAPPServerName}
echo " ======================== Done with Starting Application Server Call ======================== "
# Send an SMS & Log the activity to to get notified of the trigger.
java -jar /tmp/sendsms.jar
echo ""
echo "Log: System has been restarted by ${ClientName} having IP ${ClientIP} at datetime ${myTimeStamp}" >> /tmp/SystemRestart.log;
