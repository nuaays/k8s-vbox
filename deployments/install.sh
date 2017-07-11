#!/bin/bash

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -    
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" >> /etc/apt/sources.list.d/kubernetes.list 
apt-get update && apt-get upgrade
apt-get install -y docker.io
apt-get install -y kubelet kubeadm kubectl kubernetes-cni
touch /var/lib/cloud/instance/locale-check.skip
mv /tmp/daemon.json /etc/docker && service docker restart
