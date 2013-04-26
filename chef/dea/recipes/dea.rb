execute "git clone dea_ng" do
  cwd "/cf-deploy"
  command "git clone https://github.com/cloudfoundry/dea_ng.git"
  action :run
end

execute "install dea gems" do
  cwd "/cf-deploy/dea_ng"
  command "bundle install"
  action :run
end
