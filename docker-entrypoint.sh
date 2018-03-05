#!/bin/bash
set -eu

echo "${SCANNER_SSH_AUTHORIZED_KEYS}" > /home/scanneroperator/.ssh/authorized_keys
chown -R scanneroperator: /home/scanneroperator/.ssh
chmod 640 /home/scanneroperator/.ssh/authorized_keys

cat <<EOF > /home/scanneroperator/.odoorpcrc
[sentinel]
type = ODOO
protocol = jsonrpc
timeout = ${SCANNER_TIMEOUT:-120.0}
host = ${SCANNER_HOST}
port = ${SCANNER_PORT:-8069}
database = ${SCANNER_DB}
user = ${SCANNER_USER}
passwd = ${SCANNER_PASSWORD}
EOF

LOGFILE=/home/scanneroperator/sentinel.log
( umask 0 && truncate -s0 $LOGFILE )
tail --pid $$ -n0 -F $LOGFILE &

exec "$@"
