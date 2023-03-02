#!/bin/sh
test -d /root/.ssh || mkdir /root/.ssh

if test -e /tmp/id_rsa && test -e /tmp/id_rsa.pub; then
    cp /tmp/id_rsa /root/.ssh/
    cp /tmp/id_rsa.pub /root/.ssh/
    rm -f /tmp/id_rsa /tmp/id_rsa.pub
    chown root:root /root/.ssh/id_rsa /root/.ssh/id_rsa.pub
    chmod 0600 /root/.ssh/authorized_keys /root/.ssh/id_rsa /root/.ssh/id_rsa.pub
fi

rm -f /root/.ssh/authorized_keys
touch /root/.ssh/authorized_keys
cat /tmp/ssh-keys.pub >> /root/.ssh/authorized_keys && rm -f /tmp/ssh-keys.pub

chown root:root /root/.ssh/authorized_keys
chmod 0600 /root/.ssh/authorized_keys
