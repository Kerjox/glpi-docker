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

# Check if database file exists



if [ ! -f /data/config/config_db.php ]; then
  echo "[INFO] Database configuration file not found."
  echo "[INFO] Starting GLPI installation ..."
else
  echo "[INFO] Database configuration file found."
  echo "[INFO] Removing install.php ..."
  rm -rf /var/www/html/glpi/install/install.php
  echo "[INFO] Starting GLPI ..."
fi

if [ ! -d /data/marketplace ]; then
  mkdir -p /data/marketplace
  echo "[INFO] Marketplace directory created."
fi

if [ ! -d /data/plugins ]; then
  mkdir -p /data/plugins
  echo "[INFO] Plugins directory created."
fi

chown -R www-data. /var/www/html/glpi \
chown -R www-data. /data

apache2-foreground
