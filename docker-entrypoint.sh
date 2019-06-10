#!/bin/bash
set -x
./phabricator/bin/config set mysql.host $MYSQLHOST
./phabricator/bin/config set mysql.port $MYSQLPORT
./phabricator/bin/config set mysql.user $MYSQLUSER
./phabricator/bin/config set mysql.pass $MYSQLPASS
./phabricator/bin/config set storage.local-disk.path /files 
./phabricator/bin/config set --stdin cluster.mailers < /var/www/phabricator/conf/local/mailers.json 
sleep 10

sed -i 's#^;date\.timezone[[:space:]]=.*$#date.timezone = "America/New_York"#' /etc/php/7.2/apache2/php.ini

sed -i 's#post_max_size[[:space:]]=.*$#post_max_size = 50M#' /etc/php/7.2/apache2/php.ini

chown -R www-data:www-data /var/repo
chown -R www-data:www-data /files


# Create Database if it does not exist.
mysql -u$MYSQLUSER -p$MYSQLPASS -h$MYSQLHOST -e 'use phabricator_owners'
if  [ $? -gt 0 ]
then
sleep 30
./phabricator/bin/storage upgrade -f
fi

Phabricator Daemons
/var/www/phabricator# bin/phd

#Start apache
/usr/sbin/apache2ctl -D FOREGROUND

