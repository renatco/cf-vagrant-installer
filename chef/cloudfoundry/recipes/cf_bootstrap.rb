LOG_FILE = "/vagrant/logs/cf_bootstrap.log"

execute "run rake cf:bootstrap" do
  command <<-BASH
    su - vagrant -c /vagrant/bin/cf_bootstrap
  BASH
  not_if { ::File.exists?(LOG_FILE)}
end