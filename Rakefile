require 'rake'

desc "Init git submodules and clone required repos"
task :bootstrap do
  print "==> Init Git submodules"
  `git submodule update --init --recursive`
end

task :create_vm do
  print "==> Create Vagrant base VM using dea_ng scripts"
  `cd dea_ng`
  `bundle install`
  `rake test_vm`
end

