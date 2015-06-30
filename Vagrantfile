# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'yaml'

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

  env = ENV.fetch('BUSINEME_ENV', 'local')

  if File.exist?("config/#{env}/ips.yaml")
    ips = YAML.load_file("config/#{env}/ips.yaml")
  else
    ips = nil
  end

  config.vm.define 'api' do |api|
    api.vm.network 'private_network', ip: ips['api'] if ips
    api.vm.network "forwarded_port", guest: 8080, host: 8079
  end

  config.vm.define 'web' do |web|
    web.vm.network 'private_network', ip: ips['web'] if ips
    web.vm.network "forwarded_port", guest: 8000, host: 8001
  end
end