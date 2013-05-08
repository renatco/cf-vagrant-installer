# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ci_with_warden_prereqs"
  config.vm.box_url = "~/boxes/ci_with_warden_prereqs.box"
  config.ssh.username = "travis"
  config.vm.define "dea_test_vm"


  # config.vm.network :forwarded_port, guest: 4222, host: 4222 # NATS
  # config.vm.network :forwarded_port, guest: 5678, host: 5678 # DirectoryServerV2
  # config.vm.network :forwarded_port, guest: 80, host: 8080 # API cloud_controller_ng

  config.vm.synced_folder ".", "/cf"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider :virtualbox do |vb|
     vb.customize ["modifyvm", :id, "--memory", "1024"]
   end

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path    = ["./chef"]
    chef.provisioning_path = "/var/vagrant-chef"
    chef.log_level         = :debug
    #chef.add_recipe "apt"
    #chef.add_recipe "git"
    #chef.add_recipe "dea::packages" // ToDo: REMOVE from recipes and here
    chef.add_recipe "dea::install"
  #  chef.add_recipe "uaa::repositories"
  #  chef.add_recipe "uaa::packages"
  #  chef.add_recipe "uaa::install"
    #chef.add_recipe "cc_ng::packages"
    #chef.add_recipe "cc_ng::install"
  #  chef.add_recipe "gorouter::install"
    #ToDo: chef.add_recipe "cf-gem:::install"
  end
end
