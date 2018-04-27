#!/bin/bash
echo "# Started prune-script $(date)"

# To avoid using or overwriting anybodys credentials on the system
mkdir /tmp/prune-kube/
export KUBECONFIG=/tmp/prune-kube/config

# Login into OpenShift
# You CAN NOT use system:admin since you need a token when accessing the docker image registry
oc login https://127.0.0.1:8443/ --token='insert your token here' --insecure-skip-tls-verify=true

# pruning
echo "# prune builds"
oc adm prune builds --orphans --keep-complete=5 --keep-failed=1 --keep-younger-than=60m --confirm 

echo "# prune images"
oc adm prune images --keep-tag-revisions=3 --keep-younger-than=60m --confirm

echo "# prune deployments"
oc adm prune deployments --orphans --keep-complete=5 --keep-failed=1 --keep-younger-than=60m --confirm

rm -rf /tmp/prune-kube/
