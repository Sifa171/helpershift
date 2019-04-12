# OpenShift Pruning Container Cron Jobs

### Usecase
In OpenShift there are some Objects which retain in the platform and can easily exceed eg storage from your image registry. To prevent that you can run some oc commands and cleanup those objects. This playbook creates CronJobs in your cluster which take care of the cleanup.

### Usage
Adjust the variables in the config file and run the playbook!

```
ansible-playbook playbooks/main.yml 
```
