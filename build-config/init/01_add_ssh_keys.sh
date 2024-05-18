#!/bin/sh
test -d /root/.ssh || mkdir /root/.ssh

if test -e /tmp/id_rsa && test -e /tmp/id_rsa.pub; then
    echo "Adding id_rsa and id_rsa.pub to /root/.ssh"
    cp /tmp/id_rsa /root/.ssh/
    cp /tmp/id_rsa.pub /root/.ssh/
    rm -f /tmp/id_rsa /tmp/id_rsa.pub
    chown root:root /root/.ssh/id_rsa /root/.ssh/id_rsa.pub
    chmod 0600 /root/.ssh/authorized_keys /root/.ssh/id_rsa /root/.ssh/id_rsa.pub
fi

if test -e /root/.ssh/authorized_keys; then
    echo "Removing existing authorized_keys"
    rm -f /root/.ssh/authorized_keys
fi
touch /root/.ssh/authorized_keys

if test -e /tmp/ssh-keys.pub; then
    echo "Adding /tmp/ssh-keys.pub to /root/.ssh/authorized_keys"
    cat /tmp/ssh-keys.pub >> /root/.ssh/authorized_keys
fi

chown root:root /root/.ssh/authorized_keys
chmod 0600 /root/.ssh/authorized_keys
