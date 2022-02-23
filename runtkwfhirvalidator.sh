#Report the version numbers
PROJECT=GP_CONNECT
if [[ -e /home/service/TKW/config/$PROJECT/version_string.txt ]]
then
	cat /home/service/TKW/config/$PROJECT/version_string.txt
fi
java -jar /home/service/TKW/TKW-x.jar -version | grep -v "starting on"

if [ "$1" == '--version' ]
then
	exit 0
fi

forwarding_address=gpconnect-api
forwarding_port=19191

echo "Running as UID $UID"
echo "trustStore = " $trustStore
echo "trustStorePassword = " $trustStorePassword
echo "keyStore = " $keyStore
echo "keyStorePassword = " $keyStorePassword
echo "Making sure output structure is available"
cd /home/service/data
tar -xvf /home/service/TKW/config/$PROJECT/tkwoutputstructure.tar
cd /home/service
# decide whether its TLSMA or not

# wait until the gpconnect demonstrator docker is up before starting
/home/service/TKW/config/$PROJECT/wait-for-it.sh -t 0 $forwarding_address:$forwarding_port

props_file=/home/service/TKW/config/$PROJECT/tkw-x-forwarding.properties

sed -i -e /^tks.httpinterceptor.forwardingaddress/s/127.0.0.1/$forwarding_address/g $props_file
sed -i -e /^tks.httpinterceptor.forwardingport/s/5000/$forwarding_port/g $props_file
sed -i -e /^tks.configname/s/127.0.0.1/$forwarding_address/g $props_file
sed -i -e /^tks.configname/s/5000/$forwarding_port/g $props_file

if [ "$trustStore" == 'default' ]
then
	#ClearText
	java -version
	java -XX:+UseContainerSupport -XX:MaxRAMPercentage=80.0 -jar /home/service/TKW/TKW-x.jar -httpinterceptor $props_file
else
	#TLSMA
	java -Djavax.net.ssl.trustStore=$trustStore -Djavax.net.ssl.trustStorePassword=$trustStorePassword -Djavax.net.ssl.keyStore=$keyStore -Djavax.net.ssl.keyStorePassword=$keyStorePassword -jar /home/service/TKW/TKW-x.jar -httpinterceptor $props_file
fi
