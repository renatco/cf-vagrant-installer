require 'rake'

namespace :host do

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

end

namespace :cf do
  # -------------------------------------------------------------
  # Guest tasks

  def root_path
    File.expand_path("../", __FILE__)
  end

  def path(component)
    return '/warden/warden' if component == 'warden'
    File.expand_path("../#{component}", __FILE__)
  end

  def bundle_install component_path
    puts "==> Runing bundle install at #{component_path}"
    Dir.chdir component_path
    system "bundle install"
  end

  def cf_ruby_components
    %w(warden cloud_controller_ng dea_ng)
  end

  desc "bootstrap all cf components"
  task :bootstrap => [:bundle_install, :init_uaa,
        :init_cloud_controller_ng, :init_gorouter,
        :copy_custom_conf_files]

  desc "Install required gems for all ruby components"
  task :bundle_install do
    cf_ruby_components.each{|c| bundle_install path(c)}
    system "gem install cf"
  end

  desc "Init cloud_controller_ng database"
  task :init_cloud_controller_ng do
    puts "Initializing cloud_controller_ng database."
    Dir.chdir root_path + '/cloud_controller_ng'
    system "sudo -E bundle exec rake db:migrate"
  end

  desc "Init gorouter"
  task :init_gorouter do
    Dir.chdir root_path + '/gorouter'
    system "./bin/go install router/router"
  end

  desc "Init uaa"
  task :init_uaa => [:clone_uua_repo, :install_uua_required_pkgs]

  desc "Clone uaa repo"
  task :clone_uua_repo do
    Dir.chdir root_path
    system "git clone git://github.com/cloudfoundry/uaa.git"
  end

  desc "Install uaa required packages"
  task :install_uua_required_pkgs do
    system "sudo apt-get install --yes maven"
  end

  def cf_components
    cf_ruby_components + %w(uaa gorouter)
  end

  desc "copy custom config files"
  task :copy_custom_conf_files do
    cf_components.each do |c|
      cmd = "cp #{root_path}/custom_config_files/#{c}/*.yml #{root_path}/#{c}/config/"
      puts "==> Copying #{c} config file"
      puts "==> #{cmd}"
      system cmd
    end
  end

  desc "Set target, login and create organization and spaces"
  task :init_cf_console do
    puts "==> Initializing cf console"
    system "#{root_path}/bin/init-cf-console"
    puts "\n\nNow you can try to push the example app, like this:"
    puts ""
    puts "> cd /vagrant/sinatra-test-app"
    puts "> cf push"
  end
end
