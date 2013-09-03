# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "precise64"
  #config.vm.box = "raring64"

  # this fails like https://github.com/mitchellh/vagrant/issues/455
  # (vagrantup-provided box doesn't have the above problem)
  #config.vm.box_url = "http://cloud-images.ubuntu.com/raring/current/raring-server-cloudimg-vagrant-amd64-disk1.box"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.vm.provision :shell, :path => "setup.sh"

  config.vm.define :web1 do |web1|
      web1.vm.network :private_network, ip: "192.168.33.101"
      web1.vm.hostname = "web1"
  end
  config.vm.define :web2 do |web2|
      web2.vm.network :private_network, ip: "192.168.33.102"
      web2.vm.hostname = "web2"
  end
end
