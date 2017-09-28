#!/bin/bash
set -e

echo "${SCANNER_SSH_AUTHORIZED_KEYS}" > /home/scanneroperator/.ssh/authorized_keys
chown -R scanneroperator: /home/scanneroperator/.ssh
chmod 640 /home/scanneroperator/.ssh/authorized_keys

cat <<EOF > /home/scanneroperator/.odoo_sentinelrc
[openerp]
host = ${SCANNER_HOST}
port = ${SCANNER_PORT:-8069}
database = ${SCANNER_DB}
user = ${SCANNER_USER}
password = ${SCANNER_PASSWORD}
EOF

exec "$@"
