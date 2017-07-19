#!/bin/bash

kubeadm init --token "head12.tokenbodystring1" --apiserver-advertise-address "$apiserver" --pod-network-cidr 10.244.0.0/16
cp /etc/kubernetes/admin.conf /storage