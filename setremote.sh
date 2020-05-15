#!/bin/bash

git remote -v

#prot=https
prot=git

git remote set-url origin $prot@github.com:SimonFarrowNHS/GP_CONNECT.git

git remote -v
