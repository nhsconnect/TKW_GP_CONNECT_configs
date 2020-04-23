#!/bin/bash

while IFS=, read -r tag code diagnostics
do
	if [[ ! $tag =~ ^#.*$ ]]
	then
		echo $tag
		# convert BAD_REQUEST to Bad Request
		detail=`echo $code | sed 's/_/ /g' | sed -r 's/([^ ])([^ ]*)/\U\1\L\2/g'`
		sed -e s/__ERRORCODE__/$code/ \
			-e s/__ERRORDETAIL__/"$detail"/ \
			-e s/__ERRORTEXT__/"$diagnostics"/ \
			< operation_outcomes/operation_outcome.xml  > operation_outcomes/operation_outcome_$tag.xml
	fi
done < operation_outcomes.csv
