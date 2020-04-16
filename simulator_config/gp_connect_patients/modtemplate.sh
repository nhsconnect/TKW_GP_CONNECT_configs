#!/bin/bash

patient=9476719931 # p2
patient=9476718919 # p11
patient=9476718927 # p11
patient=9476719958 # p4
patient=9476719915 # p4
patient=9476719966 # p5
patient=9476719923 # p6
patient=9476718870 # p7
patient=9476719974 # p3
patient=9476718935 # p13
patient=9476718889 # p1

for f in $patient*.xml
do
	echo $f
	#sed -i -e "s/date value.*/date value=\"__TIMESTAMP__\"\/\>/"  $f
	sed -i -e "s/$patient/__PATIENT_1__/g"  $f
done
