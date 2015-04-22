# -*- mode: ruby -*-
# vi: set ft=ruby :

# Owncloud daily master with mail app master
# instance will be reachable at http://localhost:8120/owncloud/
# with login "admintr" and password "admintr"
# mysql root password: superdev

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

$script = <<SCRIPT
apt-get update

# pre-configure mysql root password to 'superdev'
debconf-set-selections <<< 'mysql-server mysql-server/root_password password superdev'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password superdev'
apt-get install git apache2 mysql-server --yes
apt-get install php5 php5-mysql php5-gd php5-curl --yes

# set some php.ini options to mandatory values
sed -i "s/output_buffering = .*/output_buffering = Off/" /etc/php5/apache2/php.ini
sed -i 's/;default_charset = .*/default_charset = "utf-8"/' /etc/php5/apache2/php.ini
# cli php.ini is used by the occ command
sed -i 's/;default_charset = .*/default_charset = "utf-8"/' /etc/php5/cli/php.ini
# and let's display those errors
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini

bash /vagrant/get-oc-daily.sh

echo "Done! Browse to http://localhost:8120/owncloud/"
SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "ubuntu/trusty64"

  config.vm.network "forwarded_port", guest: 80, host: 8120

  config.vm.network "private_network", ip: "192.168.33.120"

# uncomment to have a persistent copy of the source code for the mail app on your host
# you will need to create a ./src directory on the host  
#  config.vm.synced_folder "src", "/var/www/html/owncloud/apps/mail"

  config.vm.provision "shell", inline: $script

end
