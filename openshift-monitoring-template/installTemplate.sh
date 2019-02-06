#!/bin/bash

USERNAME=$1
URL=$2

if [ -z "$USERNAME" ]
then
    echo "Please provide your OCP user"
    exit 0
fi

if [ -z "$URL" ]
then
    echo "Please provide an OCP host"
    exit 0
fi

oc login -u $USERNAME $URL

OAUTHKEY=$(oc export secret grafana-datasources -n openshift-monitoring -o json | jq -r '.data."prometheus.yaml"' | base64 --decode | jq -r '.datasources[].basicAuthPassword')
sed -i.bak 's#basicAuthPassword":"#basicAuthPassword":"'"$OAUTHKEY"'#' grafana-template.yaml

oc create -f -n openshift grafana-template.yaml.bak
rm -f *.bak
echo "Finish"