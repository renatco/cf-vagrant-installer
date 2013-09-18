bash "emit provision complete" do
    user "root"
    cwd "/vagrant"
    code <<-END_OF_SCRIPT
        /sbin/initctl emit --no-wait vagrant-provisioner-complete
    END_OF_SCRIPT
end

bash "start Cloud Foundry" do
    user "root"
    code <<-END_OF_SCRIPT
      if /sbin/initctl status cf | grep -q running; then
         echo "cf job is already running"
      else
        /sbin/initctl start cf
      fi
    END_OF_SCRIPT
end
