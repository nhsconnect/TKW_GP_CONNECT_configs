#!/bin/bash

while IFS=, read -r tag code diagnostics
do
	if [[ ! $tag =~ ^#.*$ ]]
	then
		echo $tag
		sed -e s/__ERRORCODE__/$code/ \
			-e s/__ERRORDETAIL__/$code/ \
			-e s/__ERRORTEXT__/"$diagnostics"/ \
			< operation_outcomes/operation_outcome.xml  > operation_outcomes/operation_outcome_$tag.xml
	fi
done < operation_outcomes.csv
