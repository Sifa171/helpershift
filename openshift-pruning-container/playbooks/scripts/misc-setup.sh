#!/bin/bash

oc="oc --config ../playbooks/tmp/admin.kubeconfig"
$oc create -f ./tmp/crb.yml
$oc create -f ./tmp/sa.yml
