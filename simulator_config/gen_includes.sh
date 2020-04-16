#!/bin/bash

perl gen_patient_rules.pl rule > patient_rules.conf
perl gen_patient_rules.pl response > patient_responses.conf
perl gen_patient_rules.pl expression > patient_expressions.conf
