# -*- mode: ruby -*-
# vi: set ft=ruby :


#########################
# Vagrantfile variables #
#########################

sources_path_on_guest = "/root/tmp/ogam/sources"
app_module_short_name = "ogam"
dev_branch_name = "development"


# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "debian/contrib-stretch64" # Box with Virtualbox Guest Additions

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.network "private_network", ip: "192.168.50.17"
  config.vm.hostname = "agent-pos-sa-dev.example.com"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # disable the default root
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder "./puppet/environments/#{dev_branch_name}/modules", "/etc/puppetlabs/code/environments/#{dev_branch_name}/modules", create: true
  config.vm.synced_folder "./app", sources_path_on_guest, create: true

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.
  config.vm.provider "virtualbox" do |v|
    v.memory = 4096
    v.cpus = 2
    v.name = "puppet_agent-pos-sa-dev"
  end

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
  config.vm.provision "shell", privileged: true, inline: <<-SHELL
    # Puppet package
    # https://puppet.com/docs/puppet/5.3/puppet_platform.html
    wget -r -O /var/tmp/puppet.deb https://apt.puppetlabs.com/puppet5-release-stretch.deb
    dpkg -i /var/tmp/puppet.deb

    # Apt update and upgrade
    apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade

    # Puppet and git install
    apt-get install -y puppet-agent git-core
    export PATH=/opt/puppetlabs/bin:$PATH

    # r10k and bolt install
    /opt/puppetlabs/puppet/bin/gem install r10k
    /opt/puppetlabs/puppet/bin/gem install bolt

    # ssh configuration for bolt
    ssh-keygen -t rsa -b 4096
    ssh-keyscan -H -t rsa localhost,::1 >> ~/.ssh/known_hosts
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
  SHELL

  # Provisions for the "r10k.yaml" file
  config.vm.provision "file", source: "./puppet/r10k.yaml", destination: "/var/tmp/r10k.yaml"
  config.vm.provision "shell", privileged: true, inline: <<-SHELL
    mkdir /etc/puppetlabs/r10k
    mv /var/tmp/r10k.yaml /etc/puppetlabs/r10k/r10k.yaml
    chown root:root /etc/puppetlabs/r10k/r10k.yaml
  SHELL

  # Provision "deploy" to deploy the puppet code environments
  config.vm.provision "deploy", type: "shell", privileged: true, args: [dev_branch_name, app_module_short_name], inline: <<-SHELL
    /opt/puppetlabs/puppet/bin/r10k deploy environment -pv
    git -C /etc/puppetlabs/code/environments/$1/modules/$2 fetch origin
    git -C /etc/puppetlabs/code/environments/$1/modules/$2 rev-parse --verify $1
    if [ $? = 0 ]; then # The local branch already exists
      git -C /etc/puppetlabs/code/environments/$1/modules/$2 checkout $1
    else
      git -C /etc/puppetlabs/code/environments/$1/modules/$2 checkout -b $1 origin/$1
    fi
  SHELL

  # Provision "apply" to apply the init.pp manifest
  # https://www.vagrantup.com/docs/provisioning/puppet_apply.html
  config.vm.provision "apply", type: "puppet" do |puppet|
    puppet.environment_path = "./puppet/environments"
    puppet.environment = dev_branch_name
  end

  # Provision "tasks" to launch the predefined tasks
  # https://puppet.com/docs/bolt/0.x/running_tasks_and_plans_with_bolt.html
  config.vm.provision "tasks", type: "shell", privileged: true, args: [dev_branch_name, app_module_short_name], inline: <<-SHELL
    #/opt/puppetlabs/puppet/bin/bolt task show $2 --modulepath /etc/puppetlabs/code/environments/$1/modules
    #/opt/puppetlabs/puppet/bin/bolt [task_parameter_1=value_1 task_parameter_2=value_2...] -n localhost --modulepath /etc/puppetlabs/code/environments/$1/modules --run-as root
    /opt/puppetlabs/puppet/bin/bolt plan run $2 nodes=localhost environment=$1 --modulepath /etc/puppetlabs/code/environments/$1/modules --run-as root
  SHELL

end