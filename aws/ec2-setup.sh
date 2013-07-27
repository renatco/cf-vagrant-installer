#!/bin/bash -ex
usermod -l vagrant ubuntu
groupmod -n vagrant ubuntu
usermod -d /home/vagrant -m vagrant
mv /etc/sudoers.d/90-cloudimg-ubuntu /etc/sudoers.d/90-cloudimg-vagrant
perl -pi -e "s/ubuntu/vagrant/g;" /etc/sudoers.d/90-cloudimg-vagrant