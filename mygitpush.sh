#!/bin/bash
#
# commit and push scripts for GP Connect GitHub Demonstrator
#
#DRY_RUN=--dry-run

#
# Initialised with this after creating repos in github
# git remote add origin https://github.com/SimonFarrowNHS/GP_CONNECT.git
# git push -u origin master
#
# then called setremote.sh to enable private key stuff

GITROOT=git@github.com:SimonFarrowNHS

REPOS=$GITROOT/GP_CONNECT
#
BRANCH=master

git push --repo=$REPOS $DRY_RUN origin $BRANCH
