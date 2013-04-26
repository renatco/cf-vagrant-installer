execute "uaa - maven install" do
  cwd "/cf-deploy/uaa"
  command "mvn clean install -Dmaven.test.skip=true"
  action :run
end

execute "uaa - generating packages" do
  cwd "/cf-deploy/uaa"
  command "mvn package -Dmaven.test.skip=true"
  action :run
end
