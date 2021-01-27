#!/bin/sh

chown nobody:nobody /script.cob
chmod 500 /script.cob

/usr/bin/sudo -u nobody \
  /usr/local/bin/cobc \
  -Fx /script.cob -o /tmp/script && \
  /usr/bin/sudo -u nobody /tmp/script
