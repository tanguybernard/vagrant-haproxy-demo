# vi: set ft=ruby :

n = 2

Vagrant.configure("2") do |config|

  config.vm.define "loadbalancer" do |loadbalancer|
    loadbalancer.vm.box = "debian/buster64"
    loadbalancer.vm.hostname = "loadbalancer"
    loadbalancer.vm.network :private_network, ip: "192.168.50.30"
    loadbalancer.vm.network "forwarded_port", guest: 80, host: 3000
    loadbalancer.vm.network "forwarded_port", guest: 8404, host: 8404
    loadbalancer.vm.provision :shell, path: "haproxy2.sh"
  end

  # Configuration du web serveur 1
  config.vm.define :webserver1 do |webserver1_config|
    webserver1_config.vm.box = "debian/buster64"
    webserver1_config.vm.hostname = "webserver1"
    webserver1_config.vm.network :private_network, ip: "192.168.50.10"
    webserver1_config.vm.provision :shell, path: "webserver.sh"
  end
  # Configuration du web serveur 2
  config.vm.define :webserver2 do |webserver2_config|
    webserver2_config.vm.box = "debian/buster64"
    webserver2_config.vm.hostname = "webserver2"
    webserver2_config.vm.network :private_network, ip: "192.168.50.20"
    webserver2_config.vm.provision :shell, path: "webserver.sh"
  end


end




