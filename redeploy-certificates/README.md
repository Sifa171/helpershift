# Redeploy certificates

## Redeploy monitoring certificates

This is a playbook which deletes all tls-secrets and related pods in the monitoring namespace after running the redeploy-certificates.yml playbook for OpenShift to redeploy a new CA or retrofit certificates. 

### Usage

Just copy the playbook to /usr/share/ansible/openshift-ansible/playbooks/openshift-monitoring/private/ and run it. 

