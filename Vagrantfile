# -*- mode: ruby -*-
# vi: set ft=ruby :

# !!!!!!!!!!!!!!!!!!!!!!! IMPORTANT !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# !! The following parameters must be set before the vagrant up. !!
# !!!!!!!!!!!!!!!!!!!!!!! IMPORTANT !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

# app_sources_path_on_guest:
#  - Path of the directory on the guest generated per the "git clone" command.
#  - That path must contain the ".git" directory and your application sources used for the installation.
app_sources_path_on_guest = "/var/www/ogam"
# app_scripts_path_on_guest:
#  - Path of the directory on the guest containing the tasks's scripts.
#  - That scripts can be generated per puppet from templates.
app_scripts_path_on_guest = "/root/tmp/ogam/scripts"
# app_module_short_name:
#  - Set "mymodule" for a puppet module named "mypuppetuser_mymodule".
app_module_short_name = "ogam"
# branch_name: ["production", "development", "feature_*", ...]
#  - Before using it, you may have to create the corresponding branch into the control repositoy, the application module repository, the tasks...
#  - If the branch is unknow the "production" branch will be used per default.
branch_name = "development"
# deploy_type: ["puppetfile", "control_repository"]
#  - "puppetfile" option:
#    - Prefered option for development or for those who don't have access to a control repository.
#    - Check that the "branch_name" variable and the ":branch" attribute of your application module are matching.
#    - Check that "./puppet/agent-pos-sa-dev.example.com.pp" file exist and is properly configured
#    - That option can be configured via the ./puppet/Puppetfile file.
#  - "control_repository" option:
#    - Prefered option for production or for those who have access to a control repository.
#    - Check that the branch set per the "branch_name" variable exist into your control repository.
#    - Check that "manifests/agent-pos-sa-dev.example.com.pp" file exist and is properly configured into your control repository branch.
#    - That option can be configured via the ./puppet/r10k.yaml file.
deploy_type = "puppetfile"
# task_runner: ["shell", "bolt"]
#  - "shell" option:
#    - Prefered option for development because it's more verbose and quicker.
#    - Runs the scripts in "app_scripts_path_on_guest" with the root user. You must be sure that the scripts are safe before using it.
#  - "bolt" option:
#    - Prefered option for production or for modules without scripts.
#    - It is the official manner to launch Puppet tasks but it is slower too.
#    - That option can be configured via the ./puppet/bolt.yml file.
task_runner = "shell"
# excluded_dirs:
#   - Exclude directories of the synchronized folders.
#   - The first path is the local path (on the guest).
#   - The second path is the shared path (on the guest).
excluded_dirs = [[ # server vendor dir
  '/home/vagrant/ogam/server/vendor',
  app_sources_path_on_guest + '/website/htdocs/server/ogamServer/vendor'
],[ # server cache dir
  '/home/vagrant/ogam/server/app/cache',
  app_sources_path_on_guest + '/website/htdocs/server/ogamServer/app/cache'
],[ # server logs dir
  '/home/vagrant/ogam/server/app/logs',
  app_sources_path_on_guest + '/website/htdocs/server/ogamServer/app/logs'
],[ # server sessions dir
  '/home/vagrant/ogam/server/app/sessions',
  app_sources_path_on_guest + '/website/htdocs/server/ogamServer/app/sessions'
],[ # client build dir
  '/home/vagrant/ogam/client/build',
  app_sources_path_on_guest + '/website/htdocs/client/build'
]]

# !!!!!!!!!!!!!!!!!!!!!!! IMPORTANT !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

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
  config.vm.synced_folder "./puppet/environments", "/etc/puppetlabs/code/environments", create: true
  config.vm.synced_folder "./app", app_sources_path_on_guest, create: true, owner:"www-data", group: "www-data", :mount_options => ["dmode=777","fmode=777"]

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
  config.vm.provision "shell", privileged: false, inline: <<-SHELL
    # Puppet package
    # https://puppet.com/docs/puppet/5.3/puppet_platform.html
    wget -r -O /var/tmp/puppet.deb https://apt.puppetlabs.com/puppet5-release-stretch.deb
    sudo dpkg -i /var/tmp/puppet.deb

    # Apt update and upgrade
    sudo apt-get update
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade

    # Puppet and git install
    sudo apt-get install -y puppet-agent git-core
    export PATH=/opt/puppetlabs/bin:$PATH

    # r10k and bolt install
    sudo /opt/puppetlabs/puppet/bin/gem install r10k
    sudo /opt/puppetlabs/puppet/bin/gem install bolt

    # ssh configuration for vagrant user (required per bolt)
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ''
    touch ~/.ssh/known_hosts
    ssh-keyscan -H -t rsa localhost,::1 >> ~/.ssh/known_hosts
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
  SHELL

  # Provisions for the "r10k.yaml" file
  if deploy_type == "control_repository"
    config.vm.provision "file", source: "./puppet/r10k.yaml", destination: "/var/tmp/r10k.yaml"
    config.vm.provision "shell", privileged: true, inline: <<-SHELL
      # The "r10k.yaml" must be placed into the "/etc/puppetlabs/r10k" directory.
      mkdir /etc/puppetlabs/r10k
      mv /var/tmp/r10k.yaml /etc/puppetlabs/r10k/r10k.yaml
      chown root:root /etc/puppetlabs/r10k/r10k.yaml
    SHELL
  end

  # Provisions for the "Puppetfile" file
  if deploy_type == "puppetfile"
    config.vm.provision "file", source: "./puppet/Puppetfile", destination: "/var/tmp/Puppetfile"
    config.vm.provision "shell", privileged: true, args: [branch_name], inline: <<-SHELL
      # The "Puppetfile" can be placed in any directory.
      mkdir -p /etc/puppetlabs/r10k
      mv /var/tmp/Puppetfile /etc/puppetlabs/r10k/Puppetfile
      chown root:root /etc/puppetlabs/r10k/Puppetfile
    SHELL
  end

  # Provision "deploy" to deploy the puppet code environments
  config.vm.provision "deploy", type: "shell", privileged: true, args: [branch_name, app_module_short_name, deploy_type], inline: <<-SHELL
    if [ "$3" = "control_repository" ]; then
      /opt/puppetlabs/puppet/bin/r10k deploy environment -pv
    else
      /opt/puppetlabs/puppet/bin/r10k puppetfile install \
      --puppetfile /etc/puppetlabs/r10k/Puppetfile \
      --moduledir /etc/puppetlabs/code/environments/$1/modules
    fi
    # Checkout on the current branch
    # Removes the "alternates" file containing r10k's cache path on the guest which one is not accessible on the host and generate git errors.
    rm /etc/puppetlabs/code/environments/$1/modules/$2/.git/objects/info/alternates
    git -C /etc/puppetlabs/code/environments/$1/modules/$2 fetch origin 2> /dev/null
    git -C /etc/puppetlabs/code/environments/$1/modules/$2 show-ref --verify --quiet refs/heads/$1
    if [ $? = 0 ]; then # The local branch already exists
      git -C /etc/puppetlabs/code/environments/$1/modules/$2 checkout $1
    else
      git -C /etc/puppetlabs/code/environments/$1/modules/$2 checkout -b $1 origin/$1
    fi
  SHELL

  # Provisions for the "agent-pos-sa-dev.example.com.pp" file
  if deploy_type == "puppetfile"
    config.vm.provision "file", source: "./puppet/agent-pos-sa-dev.example.com.pp", destination: "/var/tmp/agent-pos-sa-dev.example.com.pp"
    config.vm.provision "shell", privileged: true, args: [branch_name], inline: <<-SHELL
      # The "agent-pos-sa-dev.example.com.pp" must be placed in the "/etc/puppetlabs/code/environments/$1/manifests" directory.
      mkdir -p /etc/puppetlabs/code/environments/$1/manifests
      mv /var/tmp/agent-pos-sa-dev.example.com.pp /etc/puppetlabs/code/environments/$1/manifests/agent-pos-sa-dev.example.com.pp
      chown root:root /etc/puppetlabs/code/environments/$1/manifests/agent-pos-sa-dev.example.com.pp
    SHELL
  end

  # Provision "apply" to run a puppet apply
  config.vm.provision "apply", type: "shell", privileged: true, args: [branch_name], inline: <<-SHELL
  	# sudo -i puppet apply -e "class {'my_class': }"
  	puppet apply --environment $1 /etc/puppetlabs/code/environments/$1/manifests/agent-pos-sa-dev.example.com.pp
  SHELL

  # Provisions for the excluded dirs
  # Must be place after the git clone of the application source code.
  excluded_dirs.each do |exclude_dir|
  config.vm.provision "shell", run:"always", path: "./vagrant-shell/exclude_synced_folder.sh",
    args: [
      exclude_dir[0], # local path
      exclude_dir[1] # shared path
    ]
  end

  # Provisions for the "bolt.yml" file
  if task_runner == "bolt"
    config.vm.provision "file", source: "./puppet/bolt.yml", destination: "/var/tmp/bolt.yml"
    config.vm.provision "shell", privileged: false, inline: <<-SHELL
      # The "bolt.yml" must be placed in the "~/.puppetlabs" directory.
      mkdir -p ~/.puppetlabs
      mv /var/tmp/bolt.yml ~/.puppetlabs/bolt.yml
    SHELL
  end

  # Provision "tasks" to launch the predefined tasks
  # https://puppet.com/docs/bolt/0.x/running_tasks_and_plans_with_bolt.html
  config.vm.provision "tasks", type: "shell", privileged: false, args: [branch_name, app_module_short_name, task_runner, app_scripts_path_on_guest], inline: <<-SHELL
    if [ "$3" = "bolt" ]; then
      # Bolt use vagrant for the ssh connection
      # /opt/puppetlabs/puppet/bin/bolt task show $2 --modulepath /etc/puppetlabs/code/environments/$1/modules
      # /opt/puppetlabs/puppet/bin/bolt task run $2 [task_parameter_1=value_1 task_parameter_2=value_2...] -n localhost --modulepath /etc/puppetlabs/code/environments/$1/modules --run-as root
      /opt/puppetlabs/puppet/bin/bolt plan run $2 nodes=localhost --run-as root
    else
      # If the tasks are independent of each other
      # sudo /bin/bash -c 'for file in $0/*; do /bin/bash $file -e $1; done' $4 $1
      # If the module provide a tasks plan
      sudo /bin/bash $4/tasks_plan.sh -e $1
    fi
  SHELL

end