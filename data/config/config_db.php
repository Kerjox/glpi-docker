<?php
class DB extends DBmysql {
   public $dbhost = '<HOST>';
   public $dbuser = '<USER>';
   public $dbpassword = '<PASS>';
   public $dbdefault = '<DATABASE>';
   public $use_utf8mb4 = true;
   public $allow_myisam = false;
   public $allow_datetime = false;
   public $allow_signed_keys = false;
}