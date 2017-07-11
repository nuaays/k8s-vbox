# -*- mode: ruby -*-

guest_os = 'ubuntu/xenial64'

nodes = [
  { :hostname => 'master',  :ram => 1024, :ip => '172.16.0.10' },
  { :hostname => 'node-01', :ram => 2048, :ip => '172.16.0.11' },
  { :hostname => 'node-02', :ram => 2048, :ip => '172.16.0.12' }
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

      config.vm.synced_folder "mnt/", "/storage", create:true, id: "storage"

      nodeconfig.vm.provision :file,  :source => "./deployments/daemon.json", :destination => "/tmp/daemon.json"
      nodeconfig.vm.provision "shell", privileged: true, path: "./deployments/install.sh"

      if node[:hostname] == 'master'
          nodeconfig.vm.provision :file,  :source => "./deployments/flannel.yaml", :destination => "/tmp/flannel.yaml"
          nodeconfig.vm.provision :file,  :source => "./deployments/kube-flannel-rbac.yaml", :destination => "/tmp/kube-flannel-rbac.yaml"
          nodeconfig.vm.provision :file,  :source => "./deployments/local-registry.yaml", :destination => "/tmp/local-registry.yaml"
          nodeconfig.vm.provision :file,  :source => "./deployments/dashboard-nodeport-svc.yaml", :destination => "/tmp/dashboard-nodeport-svc.yaml"
          nodeconfig.vm.provision :shell, privileged: true, inline: <<-SHELL
            kubeadm init --token \"head12.tokenbodystring1\" --apiserver-advertise-address 172.16.0.10 --pod-network-cidr 10.244.0.0/16
            cp /etc/kubernetes/admin.conf /storage
          SHELL
          nodeconfig.vm.provision :shell, privileged: true, env: {"nodeip" => node[:ip]}, path: "./deployments/patch_node_ip.sh"
          nodeconfig.vm.provision :shell, privileged: true, env: {"nodeip" => node[:ip]}, path: "./deployments/k8s_addons.sh"
      else 
          nodeconfig.vm.provision :shell, privileged: true, inline: "kubeadm join 172.16.0.10:6443 --token  \"head12.tokenbodystring1\""
          nodeconfig.vm.provision :shell, privileged: true, env: {"nodeip" => node[:ip]}, path: "./deployments/patch_node_ip.sh"
      end     
	  end
  end 
end
