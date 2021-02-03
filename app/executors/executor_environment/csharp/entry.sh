#!/bin/sh
chown runner:nobody /home/runner/script.csx
chmod 500 /home/runner/script.csx

sudo -u runner dotnet script /home/runner/script.csx
