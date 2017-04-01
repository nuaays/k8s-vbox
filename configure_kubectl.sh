#!/bin/bash

set -e

CLUSTER_NAME=k8s-vbox

export KUBECONFIG=mnt/admin.conf && kubectl cluster-info

