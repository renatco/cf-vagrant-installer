# Overview

This project provides a mechanism to automate several tasks to be able to set up a Vagrant VM with the following V2 (NG) Cloud Foundry components:

* Cloud Controller
* NATS
* DEA
* Gorouter
* UAA
* Warden
* Health Manager

## Requirements

* Vagrant
    - Download it from http://www.vagrantup.com (version 1.2 or higher)
    - Install required plugins:  
     `vagrant plugin install vagrant-berkshelf`  
     `vagrant plugin install vagrant-omnibus`

* Ruby 1.9.3

* (Optional) The VMware Fusion or VMware Workstation provider.  
If you do not have these installed, you can use the default VirtualBox provider (http://docs.vagrantup.com/v2/vmware/index.html)
    - Fusion:      
      `vagrant plugin install vagrant-vmware-fusion`  
      `vagrant plugin license vagrant-vmware-fusion license.lic`

    - Workstation:  
      `vagrant plugin install vagrant-vmware-workstation`  
      `vagrant plugin license vagrant-vmware-workstation license.lic`  

## Installation
```
git clone https://github.com/Altoros/cf-vagrant-installer.git
cd cf-vagrant-installer
rake host:bootstrap
```

### Provision The VM
#### Using VirtualBox
Initialize the Vagrant VM using the default VirtualBox provider. 
```
vagrant up
```
Given that the VM will be accessible from outside, this process might ask you the 
network interface which will be used to bridge the VM network interface 
(see [vagrant public networks](http://docs.vagrantup.com/v2/networking/public_network.html))

Example:
```
[cf-install] Available bridged network interfaces:
1) en0: Wi-Fi (AirPort)
2) p2p0
What interface should the network bridge to?
```
In my case I will select option 1. 

After booting, CF will be accessible from any computer in your LAN: api.cf.local

#### Using VMware Fusion / Workstation
Alternatively, you can use a different Vagrant provider such as the VMware Fusion or VMware Workstation provider. 
See the [Vagrant documentation](http://docs.vagrantup.com/v2/providers/index.html) for information on installing 
and using providers.  

> **Stop!!** If you are going to use the VMware provider, you **must** follow the instructions [here] (vmware/VMware-Instructions.md) first, or the next steps will result in an environment that will not work.

```
Fusion: vagrant up --provider=vmware_fusion
Workstation: vagrant up --provider=vmware_workstation
```

## Running Cloud Foundry
Once the Virtual Machine initializarion process is finished, CF will be always started at boot time.

Handy scripts to start, stop and check CF status:

```
# shell into the VM if you are not already there
vagrant ssh

cd /vagrant
./start.sh
./status.sh
./stop.sh
```

## Test Your New Cloud Foundry (v2) Instance

* Set up your PaaS account
CF must be up and running and it has to be done from repository root directory

```
rake cf:init_cf_cli
```

* Push a very simple sinatra application

```
cd /vagrant/test/fixtures/apps/sinatra
cf push
```

Expected output:

```
Using manifest file manifest.yml

Creating hello... OK

Creating route hello.cf.local... OK
Binding hello.cf.local to hello... OK
Uploading hello... OK
Preparing to start hello... OK
Checking status of app 'hello'...
  0 of 1 instances running (1 starting)
  ...
  1 of 1 instances running (1 running)
Push successful! App 'hello' available at http://hello.cf.local

```

Check if the app is running and working ok:

```
curl hello.cf.local

  <h3>Sinatra Test app for CF Vagrant Installer</h3>
      Hello from 0.0.0.0:61003! <br/>
```

Use "cf apps" command to list the apps you pushed:
```
cf apps
Getting applications in myspace... OK

name    status    usage     url          
hello   running   1 x 64M   hello.cf.local
```
There is also a node.js sample app in test/fixtures/apps

## Collaborate

You are welcome to contribute via [pull request](https://help.github.com/articles/using-pull-requests).
