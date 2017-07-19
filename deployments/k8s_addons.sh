#!/bin/bash

#patching flannel descriptor with api service ip
echo "setting $apiserver in flannel"
sed -i "s/\$\$apiserver/$apiserver/" /tmp/k8s_addons/flannel.yaml

# giving cluster access to kube-system service account
kubectl --kubeconfig /etc/kubernetes/admin.conf create clusterrolebinding add-on-cluster-admin --clusterrole=cluster-admin --serviceaccount=kube-system:default

# installing k8s dashboard
kubectl --kubeconfig /etc/kubernetes/admin.conf create -f https://git.io/kube-dashboard

# installing k8s addons
kubectl --kubeconfig /etc/kubernetes/admin.conf create -f /tmp/k8s_addons/