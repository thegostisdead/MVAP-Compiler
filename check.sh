#!/bin/bash
FILENAME=$1
out=$(grun calculette 'calcul' < tests-code/$FILENAME)

if [[ $out =~ "line" ]]
then
   exit 1
fi