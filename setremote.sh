#!/bin/bash

git remote -v

#prot=https
prot=git

git remote set-url origin $prot@github.com:nhsconnect/TKW_GP_CONNECT_configs.git

git remote -v
