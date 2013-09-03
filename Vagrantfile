# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "raring64"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "http://cloud-images.ubuntu.com/raring/current/raring-server-cloudimg-vagrant-amd64-disk1.box"

  config.vm.network :private_network, ip: "192.168.1.101"

  #config.vm.provision :shell, :path => "setup.sh"

  config.vm.define :web1 do |web|
      config.vm.network :private_network, ip: "192.168.1.101"
      #config.vm.network :public_network
  end
  config.vm.define :web2 do |web|
      config.vm.network :private_network, ip: "192.168.1.102"
      #config.vm.network :public_network
  end
end
