#!/bin/bash

oc="oc --config ../playbooks/tmp/admin.kubeconfig"

$oc create -f ./tmp/prune-builds.cj.yml
$oc create -f ./tmp/prune-deployments.cj.yml  
$oc create -f ./tmp/prune-images.cj.yml
