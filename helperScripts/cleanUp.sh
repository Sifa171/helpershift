#!/bin/bash

ansible-playbook -i inventory playbooks/adhoc/uninstall.yml
ansible -i inventory -b -m shell -a 'systemctl stop docker && rm -rf /var/lib/docker/* && systemctl start docker' nodes

# Maybe you have to provide your own resolv.conf
#ansible -i inventory -b -m copy -a 'src=../resolv.conf dest=/etc/resolv.conf' nodes

ansible -i inventory -b -m shell -a 'reboot' nodes
sleep 30;
ansible -i inventory -m ping all
rm facts/*
