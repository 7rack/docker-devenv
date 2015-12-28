#! /bin/bash

CATALINA_HOME=/opt/tomcat
ANT_HOME=/opt/ant

echo "stopping tomcat..."

${CATALINA_HOME}/bin/shutdown.sh
rm -f ${CATALINA_HOME}/logs/catalina.out

echo "deploying codes..."
${ANT_HOME}/bin/ant -f config/ant_build.xml

echo "starting tomcat"
${CATALINA_HOME}/bin/startup.sh
sleep 5
tail ${CATALINA_HOME}/logs/catalina.out
