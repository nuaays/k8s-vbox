# K8s cluster on vbox
Here is a simple [Vagrant](https://www.vagrantup.com) setup instantiating a [kubernetes](https://kubernetes.io) cluster. The instance features three VMs (one master, two nodes) and a [flannel](https://coreos.com/flannel/docs/latest/) overlay network. To setup the k8s instance simply execute:
 
`vagrant up` 

The setup uses the newly introduced [kubeadm](https://kubernetes.io/docs/admin/kubeadm/) tool to bring the kubernetes instance on the master node and to register the nodes. The instance also features the kubernetes [dashboard}(https://github.com/kubernetes/dashboard) UI. After installation go to the master node with

` vagrant ssh master` 

and check the kubernetes instance with

`kubectl cluster-info`

The kubernetes dashboard is accessible ion port 3200 (http://172.16.0.10:3200)
