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

      # adding nodes IPs
      nodes.each do |n|
        nodeconfig.vm.provision "shell", privileged: true, path: "./deployments/hosts.sh", env: {"hostname" => n[:hostname],"hostip" => n[:ip]} unless n[:hostname] == node[:hostname]
      end

      # adding local k8s registry for docker engine
      nodeconfig.vm.provision :file,  :source => "./deployments/daemon.json", :destination => "/tmp/daemon.json"

      # installing k8s docker and binaries
      nodeconfig.vm.provision "shell", privileged: true, path: "./deployments/install.sh"
      
      # setting up master node, adding dashboard, flannel overlay, heapster and optional local docker registry (172.16.0.10:30500)
      if node[:hostname] == 'master'
          nodeconfig.vm.provision :file,  :source => "./deployments/flannel.yaml", :destination => "/tmp/k8s_addons/flannel.yaml"
          nodeconfig.vm.provision :file,  :source => "./deployments/flannel-rbac.yaml", :destination => "/tmp/k8s_addons/flannel-rbac.yaml"
          nodeconfig.vm.provision :file,  :source => "./deployments/dashboard-svc.yaml", :destination => "/tmp/k8s_addons/dashboard-svc.yaml"
          nodeconfig.vm.provision :file,  :source => "./deployments/heapster.yaml", :destination => "/tmp/k8s_addons/heapster.yaml"
          # nodeconfig.vm.provision :file,  :source => "./deployments/registry.yaml", :destination => "/tmp/k8s_addons/registry.yaml"

          # invoking kubeadm
          nodeconfig.vm.provision :shell, privileged: true, env: {"apiserver"=>node[:ip]}, path: "./deployments/init_k8s.sh"
          
          # pathching kubelet with private node ip and restrat it
          # needed as by default kubeadm is configred to use first IP (NAT interface) as node IP
          nodeconfig.vm.provision :shell, privileged: true, env: {"nodeip" => node[:ip]}, path: "./deployments/patch_node_ip.sh"

          # installing k8s addons (flannel is patched)
          nodeconfig.vm.provision :shell, privileged: true, env: {"apiserver" => node[:ip]}, path: "./deployments/k8s_addons.sh"
      else 
      # setting up worker nodes  
          nodeconfig.vm.provision :shell, privileged: true, inline: "kubeadm join master:6443 --token  \"head12.tokenbodystring1\" --skip-preflight-checks"

          # pathching kubelet with private node ip and restrat it
          # needed as by default kubeadm is configred to use first IP (NAT interface) as node IP
          nodeconfig.vm.provision :shell, privileged: true, env: {"nodeip" => node[:ip]}, path: "./deployments/patch_node_ip.sh"
      end     
	  end
  end 
end
