#!/bin/bash -x

set -e  #exit on any error

#install kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin

#get ingress count to verify only 1 ingress matching name
count=$(kubectl -n ${NAMESPACE} get ingresses.networking.k8s.io ${INGRESSNAME}  | wc -l | tr -d ' ')

if [ $count -eq 2 ]
then
    echo "found ingress"
elif [ $count -gt 2 ]
then
    echo "too many ingress found, found $count"
    exit -1
else
    echo "ingress not found $count"
    exit -1
fi

#if ingress is found (and there is only 1) wait until it has an ALB hostname or times out
TIMEOUT=${INGRESS_TIMEOUT}
currentLoop=0
while :
do 
    ingressHostname=$(kubectl -n ${NAMESPACE} get ingresses.networking.k8s.io ${INGRESSNAME} -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")
    if [ $ingressHostname ]
    then
        echo "found $ingressHostname"
        exit 0
    fi

    if [ $currentLoop -le $((TIMEOUT * 3)) ]
    then
        sleep 20
        currentLoop=$(( currentLoop + 1))
    else
        echo "Timeout of $TIMEOUT minute(s) reached and no hostname was found"
        exit -1
    fi
done
