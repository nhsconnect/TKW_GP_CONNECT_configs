#!/bin/bash
#
#
JAVA_OPTIONS=-Dtks.skipsignlogs=Y
#java $JAVA_OPTIONS -jar ../../TKW.jar -validate tkw.properties
$JAVA_HOME/bin/java $JAVA_OPTIONS -jar ../../TKW-x.jar -validate tkw-x.properties

read -n 1 -p "Press any key to continue"
echo
