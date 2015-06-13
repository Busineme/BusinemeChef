# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "forwarded_port", guest: 8000, host: 8001

  config.vm.provision "chef_solo" do |chef|
    chef.add_recipe "busine-me::development"
    chef.json  = {
      :user => "vagrant",
      :servername => "example.example.com",
      :dbname => "busine-me",
      :staticfiles => "/opt/example/apps/example/static/",
      :postgresql => {
          :password => {
              :postgres  => "1qaz2wsx"
          }
      } 
    }
  end
end