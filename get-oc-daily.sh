#!/bin/bash

# OC_VERSION can be a branch (ex: "master") or a tag (ex: "v7.0.5")
OC_VERSION="master"
cd /var/www/html
git clone https://github.com/owncloud/core.git owncloud
cd owncloud


if [ `git branch --list ${OC_VERSION}`]
then
	# branch exists
	git checkout ${OC_VERSION}
else
	# no branch by that name, probably a tag
	git checkout -b ${OC_VERSION} ${OC_VERSION}
fi
git submodule update --init

# download latest daily build
# echo "Downloading owncloud daily tarball. This can take a few minutes."
# wget -P /root/ --no-check-certificate --quiet https://download.owncloud.org/community/daily/owncloud-daily-master.tar.bz2 
# mkdir /var/www/html/owncloud
# tar xvj --strip-components=1 --no-same-owner --no-same-permissions -f /root/owncloud-daily-master.tar.bz2 -C /var/www/html/owncloud

# get config values from autoconfig file to bypass the first-run setup screen
cp /vagrant/autoconfig.php /var/www/html/owncloud/config/
chown -R www-data:www-data /var/www/

service apache2 restart
# call index.php once to complete the install
wget --quiet http://localhost/owncloud/index.php

# list of the apps that will be installed
# uncomment next line and adapt the list to your liking
#declare -a apps=("news" "videos" "contacts" "files_antivirus" "tasks" "music" "bookmarks" "mozilla_sync" "notes" "documents")

# clone all apps and enable them
for app in "${apps[@]}"
do
	git clone https://github.com/owncloud/$app.git /var/www/html/owncloud/apps/$app
	chown -R www-data:www-data /var/www/html/owncloud/apps/$app
	cd /var/www/html/owncloud
	sudo -u www-data php occ app:enable $app
done

# install mail app
git clone https://github.com/owncloud/mail.git /var/www/html/owncloud/apps/mail
cd /var/www/html/owncloud/apps/mail
curl -sS https://getcomposer.org/installer | php
php composer.phar install
chown -R www-data:www-data /var/www/html/owncloud/apps/mail
cd /var/www/html/owncloud
sudo -u www-data php occ app:enable mail


