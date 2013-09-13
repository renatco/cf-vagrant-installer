CF_UPSTART_FILE = "/etc/init/cf.conf"

execute "run rake cf:bootstrap" do
  log_file = "/vagrant/logs/cf_bootstrap.log"

  command <<-BASH
    su - vagrant -c 'cd /vagrant && rake cf:bootstrap >> #{log_file} 2>&1'
  BASH
  not_if { ::File.exists?(CF_UPSTART_FILE) }
end
