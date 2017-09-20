#!/bin/bash
set -eux

backup_command=$(docker-compose exec backup /bin/bash -c "tail -n1 /etc/crontab | sed 's#.*\(/backup.sh.*\)\ \>\>.*#\1#g'" | cut -d' ' -f7-15)

# delete all existing backups on backuptarget
docker-compose exec backuptarget /bin/bash -c "rm -rf /backups"

# kick the backup run
docker-compose exec backup /bin/bash -c "$backup_command"

# assert backup exists on backuptarget
backup_filename=$(docker-compose exec backuptarget /bin/bash -c "ls -1 /backups/mybackup/" | grep 'mydb_.*\.sql\.gz\.gpg')

# ensure backup looks like a mysql backup
docker-compose exec backuptarget /bin/bash -c "gpg --allow-secret-key-import --import /root/test_fixtures/privkey.asc" || true
docker-compose exec backuptarget /bin/bash -c "gpg --passphrase passphrase -d /backups/mybackup/*.gpg | gunzip | head -n1" | grep "MySQL dump"