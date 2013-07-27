# -*- mode: ruby -*-
# vim: set ft=ruby sw=2 :

require 'yaml'

Vagrant.configure("2") do |config|
  config.omnibus.chef_version = "11.4.0"

  config.vm.define "cf-install"
  config.vm.box = "precise64"

  config.vm.network :forwarded_port, host: 80, guest: 80
  config.vm.network :forwarded_port, host: 8080, guest: 8080
  config.vm.network :forwarded_port, host: 8181, guest: 8181

  config.vm.provider :virtualbox do |v, override|
    override.vm.box_url = "http://files.vagrantup.com/precise64.box"
    v.customize ["modifyvm", :id, "--memory", "2048"]
  end

  config.vm.provider :vmware_fusion do |v, override|
    override.vm.box_url = "http://files.vagrantup.com/precise64_vmware.box"
    v.vmx['memsize'] = 2048
  end

  config.vm.provider :vmware_workstation do |v, override|
    override.vm.box_url = "http://files.vagrantup.com/precise64_vmware.box"
    v.vmx['memsize'] = 2048
  end

  config.vm.provider :aws do |aws, override|
    aws_config = YAML::load_file('aws/vagrant_config.yml')
    override.vm.box_url = 'https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box'
    override.vm.box = 'dummy'
    aws.access_key_id = aws_config['access_key_id']
    aws.secret_access_key = aws_config['secret_access_key']
    aws.keypair_name = aws_config['keypair_name']
    aws.ami = aws_config["ami"]
    aws.region = aws_config["region"]
    aws.instance_type = aws_config['instance_type']
    aws.security_groups = aws_config['security_groups']
    aws.user_data = File.read('aws/ec2-setup.sh')
    #override.ssh.username = "vagrant"
    override.ssh.private_key_path = aws_config['ssh.private_key_path']
  end

  config.berkshelf.enabled = true

  config.vm.provision :chef_solo do |chef|
    chef.add_recipe 'cloudfoundry::vagrant-provision-start'

    #chef.add_recipe 'apt::default'
    chef.add_recipe 'git'
    chef.add_recipe 'chef-golang'
    chef.add_recipe 'ruby_build'
    chef.add_recipe 'rbenv::user'
    chef.add_recipe 'java::openjdk'
    chef.add_recipe 'sqlite'
    chef.add_recipe 'mysql::server'
    chef.add_recipe 'postgresql::server'
    
    chef.add_recipe 'rbenv-alias'
    chef.add_recipe 'rbenv-sudo'
    chef.add_recipe 'cloudfoundry::warden'
    chef.add_recipe 'cloudfoundry::dea'
    chef.add_recipe 'cloudfoundry::uaa'
    chef.add_recipe 'cloudfoundry::cc'
    chef.add_recipe 'cloudfoundry::cf_bootstrap'

    chef.add_recipe 'cloudfoundry::vagrant-provision-end'

    chef.json = {
      'rbenv' => {
        'user_installs' => [ { 
          'user' => 'vagrant', 
          'global' => '1.9.3-p392',
          'rubies' => [ '1.9.3-p392' ],
          'gems' => {
            '1.9.3-p392' => [
              { 'name' => 'bundler' }
            ]
          },
        } ]
      },
      'rbenv-alias' => {
        'user_rubies' => [ {
          'user' => 'vagrant',
          'installed' => '1.9.3-p392',
          'alias' => '1.9.3'
        } ]
      },
      'mysql' => {
        'server_root_password' => '',
        'server_repl_password' => '',
        'server_debian_password' => ''
      },
      'postgresql' => {
        'password' => {
          'postgres' => ''
        }
      }
    }
  end
end

