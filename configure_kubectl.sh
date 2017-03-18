#!/bin/bash

set -e

CLUSTER_NAME=k8s-vbox

echo "getting kube cluster keys"

mkdir -p keys

[ -f $(pwd)/keys/admin-key.pem ] && rm -f $(pwd)/keys/admin-key.pem
[ -f $(pwd)/keys/admin.pem ] && rm -f $(pwd)/keys/admin.pem
[ -f $(pwd)/keys/ca.pem ] && rm -f $(pwd)/keys/ca.pem


scp -i .vagrant/machines/master/virtualbox/private_key -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ubuntu@172.16.0.10:/tmp/apiserver-key.pem keys/admin-key.pem
scp -i .vagrant/machines/master/virtualbox/private_key -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ubuntu@172.16.0.10:/tmp/apiserver.pem keys/admin.pem
scp -i .vagrant/machines/master/virtualbox/private_key -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ubuntu@172.16.0.10:/tmp/ca.pem keys/ca.pem

echo "configuring kube cluster $CLUSTER_NAME context"
kubectl config delete-cluster $CLUSTER_NAME 
kubectl config delete-context $CLUSTER_NAME
kubectl config set-cluster $CLUSTER_NAME --server=https://172.16.0.10:6443 --insecure-skip-tls-verify=true
kubectl config set-credentials $CLUSTER_NAME-admin --certificate-authority=ca.pem --client-key=$(pwd)/keys/admin-key.pem --client-certificate=$(pwd)/keys/admin.pem
kubectl config set-context $CLUSTER_NAME --cluster=$CLUSTER_NAME --user=$CLUSTER_NAME-admin --namespace=default
kubectl config use-context $CLUSTER_NAME 
kubectl cluster-info

