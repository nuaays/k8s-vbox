# -*- mode: ruby -*-

guest_os = 'ubuntu/xenial64'

nodes = [
  { :hostname => 'master',  :ram => 1024, :ip => '172.16.0.10' },
  { :hostname => 'node-01', :ram => 1024, :ip => '172.16.0.11' },
  { :hostname => 'node-02', :ram => 1024, :ip => '172.16.0.12' }
]

Vagrant.configure("2") do |config|

config.vm.box_check_update = false

	nodes.each do |node|
		config.vm.define node[:hostname] do |nodeconfig|
	        nodeconfig.vm.box = guest_os
  		nodeconfig.vm.network "private_network", ip: node[:ip]
  		nodeconfig.vm.hostname = node[:hostname] + ".box"

  		config.vm.provider "virtualbox" do |vb|
     		vb.gui = false
			  vb.check_guest_additions = false
			  vb.memory = node[:ram]
  		end

      nodeconfig.vm.provision :file,  :source => "./deployments/daemon.json", :destination => "/tmp/daemon.json"
      nodeconfig.vm.provision "shell", privileged: true, inline: <<-SHELL
    		curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -    
    		echo \"deb http://apt.kubernetes.io/ kubernetes-xenial main\" >> /etc/apt/sources.list.d/kubernetes.list 
			  apt-get update && apt-get upgrade
			  apt-get install -y docker.io
			  apt-get install -y kubelet kubeadm kubectl kubernetes-cni
        touch /var/lib/cloud/instance/locale-check.skip
        mv /tmp/daemon.json /etc/docker && service docker restart
      SHELL

      if node[:hostname] == 'master'
          nodeconfig.vm.provision :file,  :source => "./deployments/flannel.yaml", :destination => "/tmp/flannel.yaml"
          nodeconfig.vm.provision :file,  :source => "./deployments/local-registry.yaml", :destination => "/tmp/local-registry.yaml"
          nodeconfig.vm.provision :shell, :inline => "kubeadm init --pod-network-cidr 10.244.0.0/16 --token \"head12.tokenbodystring1\" --api-advertise-addresses 172.16.0.10", :privileged => true
          nodeconfig.vm.provision :shell, :inline => "kubectl apply -f /tmp/flannel.yaml", :privileged => true
          nodeconfig.vm.provision :shell, :inline => "kubectl create -f https://rawgit.com/kubernetes/dashboard/master/src/deploy/kubernetes-dashboard.yaml"
          nodeconfig.vm.provision :shell, :inline => "kubectl --namespace=kube-system patch service kubernetes-dashboard --type=json -p '[{\"op\": \"replace\", \"path\": \"/spec/ports/0/nodePort\", \"value\": 32000}]'"
          nodeconfig.vm.provision :shell, :inline => "kubectl create -f /tmp/local-registry.yaml", :privileged => true
      else 
          nodeconfig.vm.provision :shell, :inline => "kubeadm join 172.16.0.10 --token  \"head12.tokenbodystring1\"", :privileged => true
      end     
	  end
  end 
end
