REQUERIMENTS
===========

* vagrant = 1.2
* Ruby 1.9.3

INSTALATION
===========

```shell
# clone the repo
git clone https://github.com/Altoros/cf-vagrant-installer.git


# check that your version of vagrant is 1.1 or greater
vagrant --version

# Initialize submodules and install dependencies
git submodule update --init --recursive

# ToDo - this should: 
# cd dea_ng 
# git submodule update --init (instead of loading all buildbacks we can just start with ruby. Go has to be included)
# bundle install
# rake test_vm
rake bootstrap

# create your test VM
rake test_vm
```

We will build a Vagrant VM with the mechanisims provided by DEA_NG

# create your test VM
cd dea_ng
rake test_vm
```
This will take a while...

```shell
# Go back to the repo root folder and initialize the test VM
cd ..
vagrant up
```

RUNNING CF
===========
```
# shell into the VM
vagrant ssh

cd /cf
sudo foreman start
```

TESTING CF
===========
Install cloudfoundry (cf) gem
`sudo gem install cf` (ToDo: determine which version should be)

Set up your PaaS account
```
cf target 127.0.0.1...
cf login
>email: admin
>password: password
cf create-org
>my_org
cf create_space
>my_space
cf switch_space my_space
```

There is a very simple sinatra app included in the repo which you can push.
```
cd /cf/sinatra-app
push
```
Just follow the default options and wait until it gets up and running

to be continue...
