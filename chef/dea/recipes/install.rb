DEA_PATH = "/cf-deploy/dea_ng"

git DEA_PATH do
  repository "git://github.com/cloudfoundry/dea_ng.git"
  revision "4c1952ab69496f928dfd30d0d91064af68e486bf"
  action :sync
end

execute "dea submodules update" do
  cwd DEA_PATH
  command "git submodule update --init"
  action :run
end

execute "install dea gems" do
  cwd DEA_PATH
  command "bundle install"
  action :run
end
