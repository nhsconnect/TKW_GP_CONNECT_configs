#!/bin/bash

OPTIONS="-k -v"

AUTH="Bearer "$(java -jar ~/Documents/NetBeansProjects/JWTTools/dist/JWTTools.jar \
	/mnt/encrypted/home/simonfarrow/Documents/TKW5.0Dev/TKW/contrib/TKWAutotestManager/tstp/WebServices/host/GP_CONNECT/jwt_templates/gp_connect_jwt_template.txt \
	practitionerid 9476719931 secret true)

#EP=https://ec2-54-194-109-184.eu-west-1.compute.amazonaws.com
#EP=http://ec2-54-194-109-184.eu-west-1.compute.amazonaws.com
EP=http://127.0.0.1:4848

# get the server cert
#openssl s_client -host ec2-54-194-109-184.eu-west-1.compute.amazonaws.com -port 443 -showcerts
# import the server cert into a jks truststore
#keytool -import -alias amazon -file amazon.pem -keystore amazon.jks

# POST xml request xml response


#-X POST -d @$HOME/Documents/TKW5.0Dev/TKW/config/FHIR_REST/TestTransmission_ToC.xml \

curl $OPTIONS \
	-H "Expect:" \
	-H "Content-type: application/xml+fhir"  \
	-H "Accept: application/xml+fhir"  \
	-X POST -d @$HOME/Documents/SSP/whernside/SSP_whernside_20170719/Request_FGM_Record.xml \
	$EP/fhir/Patient/fhirmessaging

echo
read -n 1 -p "Press any key to continue ..."
echo
