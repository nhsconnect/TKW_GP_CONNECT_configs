#!/bin/bash
# usage simulator.sh [<F|SF|S|C> [<listenportno> [<forwarding port>]]]
# default C -clear
# listenport 4848
#
JAVA_OPTIONS=-Dtks.skipsignlogs=Y
#
# Test tkw properties injection
#JAVA_OPTIONS+=" -Dtks.serverBaseUrl=xxxx"

#MODE=-simulator
MODE=-httpinterceptor

TEMP=temp

case $1 in
	F)
	# forward all
	#PROPS=tkw_forward_all.properties
	PROPS=tkw-x.properties
	;;

	SF)
	# secure forward
	PROPS=tkw_forward_all_secure.properties
	;;

	S)
	# secure simulator
	PROPS=tkw_secure.properties
	;;

	C)
	# default simulate some
	PROPS=tkw-x.properties
	#PROPS=tkw.properties
	;;

	*)
	echo "Unrecognised mode $1"
	echo "usage: $0 [<F|SF|S|C> [<listenportno>]]"
	exit
	;;
esac

cp $PROPS $TEMP
PROPS=$TEMP

FORWARDING_PORT=5000
if [[ "$3" != "" ]]
then
	sed -i -e "/tks\.httpinterceptor\.forwardingport/s/$FORWARDING_PORT/$3/" $TEMP
	FORWARDING_PORT=$3
fi

if [[ "$1" == "F" ]]
then
	sed -i -e "/tks\.rules\.configuration\.file/s/test_tks_rule_config.txt/test_tks_rule_forwarder_config.txt/" $TEMP
	sed -i -e "/tks\.configname/s/FHIR_GPCONNECT/FHIR_GPCONNECT forwarding all ==> $FORWARDING_PORT/" $TEMP
fi

if [[ "$2" != "" ]]
then
	sed -i -e "/HttpTransport\.listenport/s/4848/$2/" $TEMP
fi


#$JDK8/bin/java $JAVA_OPTIONS -jar ../../TKW.jar $MODE $PROPS
$JDK11/bin/java $JAVA_OPTIONS -jar ../../TKW-x.jar $MODE $PROPS

rm -f $TEMP
