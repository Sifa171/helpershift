#!/bin/bash


INVENTORY=$1
GROUP=$2
NFS_ANSIBLE_DEST=$3
NFS=$4
PV_NAME=$5
POLICY=$6
STORAGE=$7
PV_ACCESS_MODE=$8

if [ -z "$INVENTORY" ]
then
    INVENTORY="/etc/ansible/hosts"
fi

if [ -z "$GROUP" ]
then
    GROUP="nfs"
fi

if [ -z "$NFS_ANSIBLE_DEST" ]
then
    echo "Please provide a destination for your new directory"
    exit 0
fi

if [ -z "$NFS" ]
then
    echo "Please provide a NFS host"
    exit 0
fi

if [ -z "$PV_NAME" ]
then
    echo "Please provide a Name for your PersistentVolume"
    exit 0
fi

if [ -z "$POLICY" ]
then
    echo "Please provide a ReclaimPolicy for your PersistentVolume. Should be Recycle or Retain"
    exit 0
fi

if [ -z "$STORAGE" ]
then
    echo "Please provide home much capacity your PersistentVolume will have. Should be like 5Gi"
    exit 0
fi

if [ -z "$PV_ACCESS_MODE" ]
then
    echo "Please provide an AccessMode for your PersistentVolume. Should be ReadWriteOnce, ReadWriteMany or ReadOnlyMany"
    exit 0
fi

ansible -i $INVENTORY $GROUP -m file -a "path=$NFS_ANSIBLE_DEST state=directory owner=nfsnobody group=nfsnobody mode=0777"
oc process -f pv-template.yml -p NAME=$PV_NAME -p NFS_HOST=$NFS -p NFS_PATH=$NFS_ANSIBLE_DEST -p RECLAIM_POLICY=$POLICY -p STORAGE=$STORAGE -p ACCESS_MODE=$PV_ACCESS_MODE | oc create -f -
