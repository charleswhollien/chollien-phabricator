#!/bin/bash
set -x
./phabricator/bin/config set mysql.host $MYSQLHOST
./phabricator/bin/config set mysql.port $MYSQLPORT
./phabricator/bin/config set mysql.user $MYSQLUSER
./phabricator/bin/config set mysql.pass $MYSQLPASS
./phabricator/bin/config set storage.local-disk.path /files 
sleep 10
# Create Database if it does not exist.
mysql -u$MYSQLUSER -p$MYSQLPASS -h$MYSQLHOST -e 'use phabricator_owners'
if  [ $? -gt 0 ]
then
sleep 30
./phabricator/bin/storage upgrade -f
fi

#Start apache
/usr/sbin/apache2ctl -D FOREGROUND

