# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # VAGRANT PLUGINS

  # vagrant-winnfsd
  required_plugins = %w(vagrant-hostsupdater)
  plugins_to_install = required_plugins.select { |plugin| not Vagrant.has_plugin? plugin }
  if not plugins_to_install.empty?
    puts "Installing plugins: #{plugins_to_install.join(' ')}"
    if system "vagrant plugin install #{plugins_to_install.join(' ')}"
      exec "vagrant #{ARGV.join(' ')}"
    else
      abort "Installation of one or more plugins has failed, aborting!"
    end
  end

  # COMMON SETTINGS

  nfs_mount_options = ['nolock,vers=3,udp,noatime']
  #config.winnfsd.uid = 1
  #config.winnfsd.gid = 1
  #config.nfs.map_uid = Process.uid
  #config.nfs.map_gid = Process.gid

  #insecure_key_path = "#{Dir.home()}/.vagrant.d/insecure_private_key"
  #private_key_path = "#{Dir.home()}/.ssh/id_rsa"
  public_key_path = "#{Dir.home()}/.ssh/id_rsa.pub"

  # vm_box_name = "ubuntu/focal64"
  # vm_box_description = "Ubuntu 20.04 LTS x64 Focal"
  vm_box_name = "ubuntu/bionic64"
  vm_box_description = "Ubuntu 18.04 LTS x64 Bionic"

  # This sets the username that Vagrant will SSH as by default.
  # Providers are free to override this if they detect a more appropriate user.
  # By default this is "vagrant," since that is what most public boxes
  # are made as.
  config.ssh.username = 'vagrant'

  # This sets a password that Vagrant will use to authenticate the SSH user.
  # Note that Vagrant recommends you use key-based authentication rather than
  # a password (see private_key_path) below. If you use a password,
  # Vagrant will automatically insert a keypair if insert_key is true.
  # config.ssh.password = 'vagrant'

  # If true, Vagrant will automatically insert a keypair to use for SSH,
  # replacing Vagrant's default insecure key inside the machine if detected.
  # By default, this is true.
  # If you do not have to care about security in your project and want to
  # keep using the default insecure key, set this to false.
  # This only has an effect if you do not already use private keys for
  # authentication or if you are relying on the default insecure key.
  config.ssh.insert_key = false

  # If true, agent forwarding over SSH connections is enabled.
  # Defaults to false.
  config.ssh.forward_agent = true

  # Only use Vagrant-provided SSH private keys.
  # Do not use any keys stored in ssh-agent.
  # The default value is true.
  # config.ssh.keys_only = true

  # The path to the private key to use to SSH into the guest machine.
  # By default this is the insecure private key that ships with Vagrant,
  # since that is what public boxes use. If you make your own custom box with
  # a custom SSH key, this should point to that private key.
  # You can also specify multiple private keys by setting this to be an array.
  # This is useful, for example, if you use the default private key to
  # bootstrap the machine, but replace it with perhaps a more secure key later.
  # The key that the box has at first is ~/.vagrant.d/insecure_private_key so
  # you should append this default key. Vagrant tries using private keys
  # in order, so let your major key frist.
  # config.ssh.private_key_path = [ private_key_path, insecure_key_path ]

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080,
  #   host_ip: "127.0.0.1"

  config.vm.define "provision", autostart: true, primary: true do |node|

    node.vm.box = vm_box_name
    #node.vm.box_version = vm_box_version

    node.vm.synced_folder ".", "/vagrant", disabled: true
    # , type: "nfs", mount_options: nfs_mount_options
    node.vm.synced_folder "./ansible", "/home/#{config.ssh.username}/provision"
    # , type: "nfs", mount_options: nfs_mount_options

    node.vm.hostname = "provision"

    node.vm.network "public_network", ip: "192.168.1.31",
      use_dhcp_assigned_default_route: true,
      bridge: "Realtek PCIe GBE Family Controller"
    # node.vm.network "private_network", ip: "192.168.10.31"

    node.vm.provider "virtualbox" do |vb|
      vb.memory = 1024
      vb.cpus = 1
      vb.name = "[provision] #{vm_box_description}"
      vb.auto_nat_dns_proxy = false
      vb.customize ["modifyvm", :id, "--ioapic", "on"]
      vb.customize ["modifyvm", :id, "--natdnsproxy1", "off" ]
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "off"]
    end

    node.vm.provision "shell" do |shell|
      shell.args = [
        config.ssh.username,
        File.read( public_key_path ),
        "22",
        File.read( "vagrant/mc/ini" ),
        File.read( "vagrant/mc/panels.ini" )
      ]
      shell.inline = File.read( "vagrant/provision.sh" )
    end

  end

end
