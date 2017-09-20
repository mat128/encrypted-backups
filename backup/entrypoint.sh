#!/bin/bash
set -eu
DOT_SSH="/root/.ssh"

# Setup GPG
echo "$GPG_BACKUP_PUBLIC_KEY" | gpg --import

# Setup SSH
mkdir -p ${DOT_SSH}
echo "$SSH_PRIVATE_KEY" > ${DOT_SSH}/id_rsa
chmod 600 ${DOT_SSH}/id_rsa

touch /tmp/sync.txt

echo "${CRON_SCHEDULE} root /backup.sh ${IDENTIFIER} ${MYSQL_HOST} ${MYSQL_USER} ${MYSQL_PASS} ${MYSQL_DB} ${GPG_RECIPIENT} ${TARGET_SSH_HOST} ${TARGET_SSH_USER} >> /tmp/sync.txt 2>&1" >> /etc/crontab
cat /etc/crontab
tail -f /tmp/sync.txt &

set -x
cron -f -L 15