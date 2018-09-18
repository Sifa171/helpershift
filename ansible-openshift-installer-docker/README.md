# Ansible OpenShift installer as DockerImage

### Usecase
In most of the customer environments you only have one bastion host for several OpenShift environments and maybe also differents versions. 
This playbook will create a Dockerfile and copies all of the required files especially for the requirements of the OpenShift version. <br>
Pay attention! This is not finished yet! 

### Usage
Adjust the vars section in the hosts file and run the playbook!

```
ansible-playbook playbooks/main.yml 
```
