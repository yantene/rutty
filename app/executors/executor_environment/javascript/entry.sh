#!/bin/sh

chown nobody:nobody /script.js
chmod 500 /script.js

/usr/bin/sudo -u nobody /usr/local/bin/node /script.js
