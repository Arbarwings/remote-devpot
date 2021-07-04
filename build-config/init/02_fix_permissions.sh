#!/bin/sh
sysctl -p
usermod -u 1000 -d /workspace -s /bin/bash www-data
chown -R www-data:www-data /workspace && chmod 775 -R /workspace
