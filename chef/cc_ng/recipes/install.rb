execute "git clone cloud_controller_ng" do
  cwd "/cf-deploy"
  command "git clone https://github.com/cloudfoundry/cloud_controller_ng.git"
  action :run
end

execute "install cloud_controller_ng gems" do
  cwd "/cf-deploy/cloud_controller_ng"
  command "bundle install"
  action :run
end

execute "run db:migrate" do
  cwd "/cf-deploy/cloud_controller_ng"
  command "bundle exec rake db:migrate"
  action :run
end
