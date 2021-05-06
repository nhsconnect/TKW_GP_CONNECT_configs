#!/bin/bash
# usage simulator.sh [<F|SF|S|C> [<listenportno> [<forwarding port>]]]
# default C -clear
# listenport 4848
#
# NB This clones and edits tkw-x.properties it never runs tkw-x-forwarding.properties
#
JAVA_OPTIONS=-Dtks.skipsignlogs=Y
#
# Test tkw properties injection
#JAVA_OPTIONS+=" -Dtks.serverBaseUrl=xxxx"
#JAVA_OPTIONS+=" -Djavax.net.debug=all"

#MODE=-simulator
MODE=-httpinterceptor

TEMP=temp

# This file is used as a template but the ensuing default edits for the F option make it identical to the forwarder props file
PROPS=tkw-x.properties

case $1 in
	F)
	# forward all
	;;

	SF|FS)
	# secure forward
	;;

	S)
	# secure simulator
	;;

	C)
	# default simulate some
	;;

	*)
	echo "Unrecognised mode $1"
	echo "usage: $0 [<F|SF|S|C> [<listenportno>]]"
	exit
	;;
esac

cp $PROPS $TEMP
PROPS=$TEMP

#===================================================================================
# forwarding port

# default value
FORWARDING_PORT=5000
if [[ "$3" != "" ]]
then
	# replace default
	sed -i -e "/tks\.httpinterceptor\.forwardingport/s/$FORWARDING_PORT/$3/" $TEMP
	FORWARDING_PORT=$3
fi

#===================================================================================
# mode

# forward
if [[ "$1" =~ ^.*F.*$  ]]
then
	# modify rules file and forwarding port
	sed -i -e "/tks\.rules\.configuration\.file/s/test_tks_rule_config.txt/test_tks_rule_forwarder_config.txt/" $TEMP
	sed -i -e "/tks\.configname/s/FHIR_GPCONNECT/FHIR_GPCONNECT forwarding all ==> $FORWARDING_PORT/" $TEMP
fi

# secure
if [[ "$1" =~ ^.*S.*$ ]]
then
	# modify TLS setting
	sed -i -e "/tks\.receivetls/s/No/Yes/" $TEMP
	sed -i -e "/tks\.configname/s/$/ secure/" $TEMP
fi

#===================================================================================
# listen port

if [[ "$2" != "" ]]
then
	# modify listen port
	sed -i -e "/HttpTransport\.listenport/s/4848/$2/" $TEMP
fi

#===================================================================================

#$JDK8/bin/java $JAVA_OPTIONS -jar ../../TKW.jar $MODE $PROPS
$JDK11/bin/java $JAVA_OPTIONS -jar ../../TKW-x.jar $MODE $PROPS

rm -f $TEMP
