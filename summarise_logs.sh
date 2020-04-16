#!/bin/bash
#
# loop though log files in a saved messages folder and build a summarising web page showing http method context path and ssp interaction id
# per interaction
#

n=0

echo '<html><body>'
echo '<table border="1" cellpadding="0" cellspacing="0">'
echo '<col width="5%"/>'
echo '<col width="20%"/>'
echo '<col width="35%"/>'
echo '<col width="30%"/>'
echo '<col width="10%"/>'
echo '<tr><th>Index</th><th>Filename</th><th>Request method and context path</th><th>Interaction Id</th><th>Response code</th></tr>'

# we can rely on the files being returned in alpha order
# unfortunately that not what we want!
folder=simulator_saved_messages
cd $folder

IFS='
'
for f in `ls -tr *.log`
do
	if [[ -e $f ]]
	then
		((n++))
		cp=`head -n 1 $f | sed -e s/\s*HTTP.*$//g`
		interactionid=`sed -n -e /InteractionId/p < $f | sed -e s/^Ssp-InteractionId:// -e s/\\\r//g`
		response=`sed -n -e /^HTTP/p < $f | sed -e s/\\\r//g`
		echo "<tr><td align=\"right\">$n</td><td><a href=\"$folder\\$f\">$f</a></td><td>$cp</td><td>$interactionid</td><td>$response</td></tr>"
	fi
done

echo '</table></body></html>'
