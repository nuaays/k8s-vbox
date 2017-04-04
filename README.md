Switched to kubeadm 1.6.1 (unstable) due to [issue](https://github.com/kubernetes/kubernetes/issues/43808) with #kubernetes 1.6.1

# K8s cluster on vbox
Here is a simple [Vagrant](https://www.vagrantup.com) setup instantiating a [kubernetes](https://kubernetes.io) cluster. The instance features three VMs (one master, two nodes) and a [flannel](https://coreos.com/flannel/docs/latest/) overlay network. To setup the k8s instance simply execute:
 
`vagrant up` 

The setup uses the newly introduced [kubeadm](https://kubernetes.io/docs/admin/kubeadm/) tool to bring the kubernetes instance on the master node and to register the nodes. The instance also features the kubernetes [dashboard](https://github.com/kubernetes/dashboard) UI. After installation go to the master node with

`vagrant ssh master` 

and check the kubernetes instance with

`kubectl cluster-info`

The kubernetes dashboard is accessible on port 32000 (http://172.16.0.10:32000)

There is docker remote repository deployed on the master node accessible via 172.16.0.10:30500. Images can be pushed with docker push 172.16.0.10:30500/${TAG}:${VERSION}. The repository is insecure and the appropriate configuration should be present in the local docker engine from where the image is pushed. For a configuration example see [deployments/daemon.json](deployments/daemon.json)

To use kubectl on the host update to the [latest version](https://kubernetes.io/docs/tasks/kubectl/install/) and export KUBECONFIG env variable pointing at mnt/admin.conf

`export KUBECONFIG=mnt/admin.conf && kubectl cluster-info`

Example can be found in configure_kubectl.sh

The cluster info should be visible with kubectl cluster_info
