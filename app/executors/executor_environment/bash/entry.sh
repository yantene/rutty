#!/bin/sh

chown nobody:nobody /script.sh
chmod 500 /script.sh

/usr/bin/sudo -u nobody /bin/bash /script.sh
