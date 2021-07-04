#!/bin/sh
test -d /root/.ssh && mkdir /root/.ssh

rm -f /root/.ssh/authorized_keys
touch /root/.ssh/authorized_keys
cat /tmp/ssh-keys.pub >> /root/.ssh/authorized_keys && rm -f /tmp/ssh-keys.pub

chown root:root /root/.ssh/authorized_keys
chmod 0600 /root/.ssh/authorized_keys
