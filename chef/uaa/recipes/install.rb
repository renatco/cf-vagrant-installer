execute "git clone uaa" do
  cwd "/cf-deploy"
  command "git clone https://github.com/cloudfoundry/uaa.git"
  action :run
end

execute "install java uaa packages" do
  cwd "/cf-deploy/uaa"
  command "mvn clean install"
  action :run
end
