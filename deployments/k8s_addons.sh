#!/bin/bash

kubectl --kubeconfig /etc/kubernetes/admin.conf create -f https://git.io/kube-dashboard
kubectl --kubeconfig /etc/kubernetes/admin.conf create -f /tmp/dashboard-nodeport-svc.yaml
kubectl --kubeconfig /etc/kubernetes/admin.conf create -f /tmp/local-registry.yaml
kubectl --kubeconfig /etc/kubernetes/admin.conf create clusterrolebinding add-on-cluster-admin --clusterrole=cluster-admin --serviceaccount=kube-system:default
kubectl --kubeconfig /etc/kubernetes/admin.conf apply -f /tmp/kube-flannel-rbac.yaml
kubectl --kubeconfig /etc/kubernetes/admin.conf apply -f /tmp/flannel.yaml
