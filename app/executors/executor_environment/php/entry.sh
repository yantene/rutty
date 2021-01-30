#!/bin/sh

chown nobody:nobody /script.php
chmod 500 /script.php

/usr/bin/sudo -u nobody /usr/local/bin/php /script.php
