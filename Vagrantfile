Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.network :forwarded_port, guest: 22, host: 2202, id: "ssh" #ssh
  config.vm.network :forwarded_port, guest: 80, host: 8002 #web
  config.vm.network :forwarded_port, guest: 3306, host: 33602 #mysql
  config.vm.network :forwarded_port, guest: 1080, host: 10802 #maildev

  config.vm.provision :shell, path: "bootstrap.sh"

  config.vm.synced_folder ".", "/var/www/html", type: "rsync",
      rsync__exclude: [".idea", ".git/", "vendor/", "node_modules/", "var/cache", "web/public", "var/logs"]

  config.vm.hostname = "applicationname"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
    vb.cpus = "1"
  end
  config.ssh.forward_agent = true
end
