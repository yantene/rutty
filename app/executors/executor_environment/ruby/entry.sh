#!/bin/sh

chown nobody:nobody /script.rb
chmod 500 /script.rb

/usr/bin/sudo -u nobody /usr/local/bin/ruby /script.rb
