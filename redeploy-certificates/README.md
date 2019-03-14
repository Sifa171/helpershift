# Redeploy certificates

## Redeploy monitoring certificates

This is a playbook which deletes all tls-secrets and related pods in the monitoring namespace after running the redeploy-certificates.yml playbook for OpenShift to redeploy a new CA or retrofit certificates. 

### Usage

Just copy the playbook to /usr/share/ansible/openshift-ansible/playbooks/openshift-monitoring/private/ and run it. 

## Redeploy logging certificates

This is a playbook which deletes all tls-secrets and related pods in the logging namespace after running the redeploy-certificates.yml playbook for OpenShift to redeploy a new CA or retrofit certificates.
It uses for certificate regenerartion the original config.yaml playbook for logging.

### Usage

Just copy the playbook to /usr/share/ansible/openshift-ansible/playbooks/openshift-logging/private/ and run it.

