#!/bin/bash

INVENTORY=$1

if [ -z "$INVENTORY" ]
then
    INVENTORY="/etc/ansible/hosts"
fi

ansible -i $INVENTORY masters -m shell -a"systemctl stop atomic-openshift-master-api"
ansible -i $INVENTORY masters -m shell -a"systemctl stop atomic-openshift-master-controllers"
ansible -i $INVENTORY nodes -m shell -a"systemctl stop atomic-openshift-node"
ansible -i $INVENTORY nodes -m shell -a"systemctl restart openvswitch"
sleep 5
ansible -i $INVENTORY masters -m shell -a"systemctl start atomic-openshift-master-api"
ansible -i $INVENTORY masters -m shell -a"systemctl start atomic-openshift-master-controllers"
sleep 10
echo "Make sure masters are up before nodes"
ansible -i $INVENTORY masters -m shell -a"systemctl start atomic-openshift-node"
sleep 5
ansible -i $INVENTORY nodes -m shell -a"systemctl start atomic-openshift-node"