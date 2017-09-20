#!/bin/bash
set -eux

IDENTIFIER=$1; shift
MYSQL_HOST=$1; shift
MYSQL_USER=$1; shift
MYSQL_PASS=$1; shift
MYSQL_DB=$1; shift
GPG_RECIPIENT=$1; shift
TARGET_SSH_HOST=$1; shift
TARGET_SSH_USER=$1; shift

dump() {
    local host=$1
    local user=$2
    local pass=$3
    local db=$4

    mysqldump --routines --host=$host --user=$user --password=$pass $db
}

compress() {
    gzip
}

encrypt() {
    local recipient=$1

    gpg --encrypt --always-trust --recipient $recipient
}

send() {
    local host=$1
    local user=$2
    local db=$3

    ssh -i /root/.ssh/id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=false $host -l $user "mkdir -p /backups/${IDENTIFIER}/ && cat > /backups/${IDENTIFIER}/${db}_$(date "+%Y-%m-%d_%H-%M-%S").sql.gz.gpg"
}

dump $MYSQL_HOST $MYSQL_USER $MYSQL_PASS $MYSQL_DB | compress | encrypt $GPG_RECIPIENT | send ${TARGET_SSH_HOST} ${TARGET_SSH_USER} ${MYSQL_DB}
