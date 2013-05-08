require 'rake'

desc "Initialize repos and vagrant vm"
task :bootstrap => :create_vm

task :create_vm => :update_git_submodules do
  puts "==> Create Vagrant base VM using dea_ng scripts"
  system "cd dea_ng && bundle install"
  system "cd dea_ng && rake test_vm"
end

desc "Init git submodules and clone required repos"
task :update_git_submodules do
  puts "==> Init Git submodules"
  system "git submodule update --init --recursive"
end

# -------------------------------------------------------------
# Guest tasks

def path(component)
  return '/warden/warden' if component == 'warden'
  File.expand_path("../#{component}", __FILE__)
end

def bundle_install component_path
  puts "==> Runing bundle install at #{component_path}"
  Dir.chdir component_path
  system "bundle install"
end

desc "Install required gems for all ruby components"
task :bundle_install do
  ruby_components = %w(warden cloud_controller_ng dea_ng)
  ruby_components.each{|c| bundle_install path(c)}
end
