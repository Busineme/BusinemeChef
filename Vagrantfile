# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.network "forwarded_port", guest: 8000, host: 80
  config.vm.network "forwarded_port", guest: 8080, host: 8081

  config.vm.provision "chef_solo" do |chef|
    chef.add_recipe "busine-me::development"
  end
end