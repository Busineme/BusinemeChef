# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "forwarded_port", guest: 8000, host: 8001

  env = ENV.fetch('BUSINEME_ENV', 'local')

  if File.exist?("config/#{env}/ips.yaml")
    ips = YAML.load_file("config/#{env}/ips.yaml")
  else
    ips = nil
  end

  config.vm.define 'api' do |api|
    api.vm.provider "virtualbox" do |vm, override|
      override.vm.network 'private_network', ip: ips['api'] if ips
    end
  end

  config.vm.define 'web' do |web|
    web.vm.provider "virtualbox" do |vm, override|
      override.vm.network 'private_network', ip: ips['web'] if ips
    end
  end

  # config.vm.provision "chef_solo" do |chef|
  #   chef.add_recipe "busine-me::development"
  #   chef.json  = {
  #     :user => "vagrant",
  #     :servername => "example.example.com",
  #     :dbname => "busine-me",
  #     :staticfiles => "/opt/example/apps/example/static/",
  #     :postgresql => {
  #         :password => {
  #             :postgres  => "1qaz2wsx"
  #         }
  #     } 
  #   }
  # end
end