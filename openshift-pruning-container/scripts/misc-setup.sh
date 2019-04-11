#!/bin/bash

oc="oc --config ../playbooks/tmp/admin.kubgeconfig"

$oc ./playbooks/tmp/crb.yml
$oc ./playbooks/tmp/sa.yml