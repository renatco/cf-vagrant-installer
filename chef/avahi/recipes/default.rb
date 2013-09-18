package "python-avahi" do
  action :install
end

execute "set up avahi" do
  command "cp /vagrant/chef/avahi/avahi-daemon.conf /etc/avahi"
end