#!/bin/bash
#
# This is the main script that runs in the docker container. It
#   starts tomcat, preps the runTdm.sh script, starts the TDM, and
#   dumps the user into a bash directory.
#
echo "Starting tomcat..."
/bin/bash /usr/local/tomcat/bin/startup.sh

#
# Only start the TDM is threddsConfig.xml is found
#   This is importiant when the TDS is started for the 
#   first time and an external content directory is not
#   mounted with a `docker -v` option.
#
echo "Waiting for tomcat to start..."
while [ ! -f /usr/local/tomcat/content/thredds/threddsConfig.xml ]
do
  sleep 0.5s
done

echo "Starting the TDM"

#
# Get the docker container IP, add the https and add the port number to 
#   the IP address. The SSL enabled port number is assumed to be 8443.
#
IP=`/sbin/ip route | awk '/scope/ { print $9 }'`
IP="https://$IP:8443/"
echo `cat /usr/local/tomcat/content/tdm/runTdm.sh`$IP > /usr/local/tomcat/content/tdm/runTdm.sh 

/bin/bash /usr/local/tomcat/content/tdm/runTdm.sh&

echo "Let's play!"
cat /usr/local/tomcat/content/tdm/runTdm.sh
/bin/bash
