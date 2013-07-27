
bash "emit provision complete" do
    user "root"
    cwd "/vagrant"
    code <<-END_OF_SCRIPT
        /sbin/initctl emit --no-wait vagrant-provisioner-complete
    END_OF_SCRIPT
end


bash "AWS DNS setup" do
  user "root"
  cwd "/vagrant/custom_config_files"
  code <<-END_OF_SCRIPT
        EXT_IP=$(curl http://instance-data/latest/meta-data/public-ipv4)
        XIP_IO_HOST=$EXT_IP.xip.io
        XIP_IO_SHORT=$(host $XIP_IO_HOST| head -1 | cut  -d ' '  -f6 | rev |cut -c 2- | rev)
        find . -type f -print0 | xargs -0 sed -i 's/vcap.me/'"$XIP_IO_SHORT"'/g'
  END_OF_SCRIPT
  only_if { node[:virtualization][:system] == "xen" }
end
