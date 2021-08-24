#!/bin/bash

#Check for working redirect until timeout on App Yaml
for (( ; ; ))
do
    sleep 1
    if [[ $(wget -S -T1 -t1 "http://${REDIRECT}/" 2>&1 | grep "HTTP/1" | awk '{print $2}') == "200" ]] ; then
        echo "connected to ${REDIRECT}"
        exit 0
    else
        echo "cannot connect to ${REDIRECT}"
    fi
done
exit 1