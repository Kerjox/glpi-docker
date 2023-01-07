#!/bin/bash

echo """
 _______  _        ______   _
(_______)(_)      (_____ \ | |
 _   ___  _        _____) )| |
| | (_  || |      |  ____/ | |
| |___) || |_____ | |      | |
 \_____/ |_______)|_|      |_|
                              
      Kerjox v10.0.5

"""

cp /data/config/config_db.php.bak /data/config/config_db.php
rm /var/www/html/glpi/install/install.php
sed -i "s/<HOST>/$MARIADB_HOST:$MARIADB_PORT/g" /data/config/config_db.php
sed -i "s/<USER>/$MARIADB_USER/g" /data/config/config_db.php
sed -i "s/<PASS>/$MARIADB_PASSWORD/g" /data/config/config_db.php
sed -i "s/<DATABASE>/$MARIADB_DATABASE/g" /data/config/config_db.php
echo "[INFO] Database configuration ...... OK"

echo "[INFO] GLPI configuration ...... OK"
apache2-foreground