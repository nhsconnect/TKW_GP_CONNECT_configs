#!/bin/bash
#
# spool up the answer demonstrator
#
export JDK8=/usr/lib/jvm/java-8-openjdk-amd64

ROOT=~/Documents/git_repositories

case $1 in 
	0.7)
		cd $ROOT/gpconnect-demonstrator-release-0.7
		./start_gpconnect.sh
		;;
	1.2)
		cd $ROOT/gpconnect-demonstrator-release-1.2
		docker-compose -f gpconnect.yml up
		;;
	1.2-opentest)
		cd $ROOT/gpconnect-demonstrator-release-1.2
		docker-compose -f gpconnect-opentest.yml up
		;;
	1.3|1.5)
		cd $ROOT/gpconnect-demonstrator-develop
		./start_gpconnect.sh
		#docker-compose -f gpconnect.yml up
		;;
	*)
		cd $ROOT/gpconnect-demonstrator-release-0.5.0
		./start_gpconnect.sh
		;;
esac

