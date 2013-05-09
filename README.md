This project provides a mechanism to automate several tasks to be able to set up a Vagrant VM with the following V2 (NG) Cloud Foundry components:
* NATS
* DEA
  * Directory Server
  * File Server
  * Warden
* Cloud Controller
* Gorouter
* UAA

REQUIREMENTS
--
* vagrant = 1.2
```vagrant --version```
* Ruby 1.9.3

INSTALATION
--
It is done in two phases (rake tasks)
* Host

```
# clone the repo
git clone https://github.com/Altoros/cf-vagrant-installer.git
cd cf-vagrant-installer
# Set up host computer
rake host:bootstrap
```

This will take a some time... 

Initialize vagrant VM
```
vagrant up
```

* Guest (inside Vagrant VM)

```
# Shell into the VM 
vagrant ssh
cd /vagrant
rake cf:bootstrap
```

RUNNING CF
--

```
# shell into the VM if you are not already there
vagrant ssh

cd /vagrant
foreman start
```

Note: UAA requires lot of dependencies which will download only once.

TEST YOUR CF
--
* Set up your PaaS account
You can do it:
Manually:

```
cf target http://127.0.0.1:8181
cf login
>email: admin
>password: password
cf create-org
>my_org
cf create_space
>my_space
cf switch_space my_space
```

Or automatically:

```
cd /vagrant
rake cf:init_cf_console 
```

* Push a very simple application
There is a very simple sinatra app included in the repo which we will use as an example

```
cd /vagrant/sinatra-test-app
cf push
Name> my_app
Instances> 1
Custom startup command> none
Memory Limit> 256M
Subdomain> my_app
Domain> vcap.me
Create services for application?> n
Save configuration?> n
```

You are supposed to get:

```
Uploading my_app... OK
Starting my_app... OK
```

This is a staging step. WARN: it will not deploy yet :(

```
-----> Downloaded app package (4.0K)
Installing ruby.
-----> Using Ruby version: ruby-1.9.2
-----> Installing dependencies using Bundler version 1.3.2
       Running: bundle install --without development:test --path vendor/bundle --binstubs vendor/bundle/bin --deployment
       Fetching gem metadata from http://rubygems.org/..........
       Fetching gem metadata from http://rubygems.org/..
       Installing rack (1.5.1)
       Installing rack-protection (1.3.2)
       Installing tilt (1.3.3)
       Installing sinatra (1.3.4)
       Using bundler (1.3.2)
       Your bundle is complete! It was installed into ./vendor/bundle
       Cleaning up the bundler cache.
-----> Uploading staged droplet (21M)
Checking my_app...
Application failed to stage
```


Given that we are building everything up from the source code repositories, we are hitting some roadblocks which we are trying to fix collaborating with the vcap-dev mailing list.



Collaborate
--
You are welcome to contribute via pull request
