#!/bin/bash

echo "nodeip: ${nodeip}"
sed -i "/Environment=\"KUBELET_CADVISOR_ARGS=--cadvisor-port=0\"/a Environment=\"KUBELET_EXTRA_ARGS=--node-ip=${nodeip}\"" /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
systemctl daemon-reload
systemctl restart kubelet
