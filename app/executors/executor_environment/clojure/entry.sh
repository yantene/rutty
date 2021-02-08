#!/bin/sh

chown nobody:nobody /script.clj
chmod 500 /script.clj

/usr/local/bin/clojure -M /script.clj
