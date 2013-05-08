PATH = "/cf/cloud_controller_ng"

execute "install and update git submodules" do
  user 'travis'
  cwd PATH
  command "git submodule update --init --recursive && touch /tmp/cc_submodules_installed.ack"
  action :run
  not_if do ::File.exists?('/var/cc_submodules_installed.ack') end
end

execute "install cloud_controller_ng gems" do
  cwd PATH
  user 'travis'
  command "bundle > bundle.log && touch /tmp/cc_bundle_install.ack"
  action :run
  not_if do ::File.exists?('/var/cc_bundle_install.ack') end
end

execute "run db:migrate" do
  cwd PATH
  user 'travis'
  command "bundle exec rake db:migrate && touch /tmp/cc_db_migrate.ack"
  action :run
  not_if do ::File.exists?('/var/cc_db_migrate.ack') end
end
