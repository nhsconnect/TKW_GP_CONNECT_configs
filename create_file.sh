#!/bin/bash
#
# create xml fhir binary response for large text files containing the randomnly generated alphanumerics
#

FILE=file

if [[ "$1" == "" ]]
then
	mb=1
else
	mb=$1
fi
#count=$(($mb * 759))
count=$(($mb * 1000000))

echo $count

#dd if=/dev/zero of=$FILE.txt count=$count bs=1024
## replace null with 'A'
#tr '\0' 'A' < $FILE.txt > $FILE.A.txt

< /dev/urandom tr -dc "[:alnum:]" | head -c$(($count)) > $FILE.A.txt

# base 64 encode
openssl base64 -in $FILE.A.txt -out $FILE.b64.txt

case $mb in
	10)
	# patient 4
	index=2
	;;
	20)
	# patient 5
	index=3
	;;
	50)
	# patient 6
	index=4
	;;
	95)
	# patient 7
	index=5
	;;
	105)
	# patient 8
	index=6
	;;
	*)
	index=7
	;;
esac

cat head.txt file.b64.txt tail.txt |  tr -d '\n' | sed s/07a6483f-732b-461e-86b6-edb665c45511/07a6483f-732b-461e-86b6-edb665c4551$index/ > simulator_config/responses/binary.$mb.xml

rm -f $FILE.txt $FILE.b64.txt $FILE.A.txt
