#!/bin/bash
#
# spool up the answer dmonstrator
#
export JDK8=/usr/lib/jvm/java-8-openjdk-amd64

ROOT=~/Documents/git_repositories

case $1 in 
	0.7)
		cd $ROOT/gpconnect-demonstrator-release-0.7
		;;
	1.2)
		cd $ROOT/gpconnect-demonstrator-release-1.2
		;;
	1.3)
		cd $ROOT/gpconnect-demonstrator-develop
		;;
	*)
		cd $ROOT/gpconnect-demonstrator-release-0.5.0
		;;
esac

./start_gpconnect.sh
