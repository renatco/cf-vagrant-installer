# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ci_with_warden_prereqs"
  config.vm.box_url = "~/boxes/ci_with_warden_prereqs.box"
  config.ssh.username = "travis"
  config.vm.define "dea_test_vm"


  config.vm.network :forwarded_port, guest: 80, host: 8181 # API cloud_controller_ng


  config.vm.provider :virtualbox do |vb|
     vb.customize ["modifyvm", :id, "--memory", "2048"]
   end

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path    = ["./chef"]
    chef.provisioning_path = "/var/vagrant-chef"
    chef.log_level         = :debug
    chef.add_recipe "apt"
    chef.add_recipe "git"
  end
end
