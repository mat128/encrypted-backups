This container image allows doing regular database backups (currently mysql only),
encrypt them with GPG and send them to a remote host via SSH.

Everything is driven from environment variables.

Typical usage (in a docker-compose file):

      service:
          backup:
            image: mat128/encrypted-backups:1.0
            environment:
              IDENTIFIER: unique_identifier
              MYSQL_HOST: mariadbserver
              MYSQL_USER: myuser
              MYSQL_PASS: mypassword
              MYSQL_DB: mydb
              CRON_SCHEDULE: "*/15 * * * *"
              GPG_RECIPIENT: test@example.org
              GPG_BACKUP_PUBLIC_KEY: |
                -----BEGIN PGP PUBLIC KEY BLOCK-----
                <snip>
                -----END PGP PUBLIC KEY BLOCK-----
              SSH_PRIVATE_KEY: |
                -----BEGIN RSA PRIVATE KEY-----
                <snip>
                -----END RSA PRIVATE KEY-----
              TARGET_SSH_HOST: mybackupserver.example.org
              TARGET_SSH_USER: backup
