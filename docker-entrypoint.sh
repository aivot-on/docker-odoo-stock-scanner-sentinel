#!/bin/bash
set -eu

echo "${SCANNER_SSH_AUTHORIZED_KEYS}" > /home/scanneroperator/.ssh/authorized_keys
chown -R scanneroperator: /home/scanneroperator/.ssh
chmod 640 /home/scanneroperator/.ssh/authorized_keys

cat <<EOF > /home/scanneroperator/.odoorpcrc
[sentinel]
type = ODOO
protocol = ${SCANNER_PROTOCOL:-jsonrpc}
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

# https://github.com/docker-library/mysql/issues/47#issuecomment-147397851
asyncRun() {
    "$@" &
    pid="$!"
    trap 'echo ''Stopping PID $pid''; kill -SIGTERM $pid' SIGINT SIGTERM

    # A signal emitted while waiting will make the wait command return code > 128
    # Let's wrap it in a loop that doesn't end before the process is indeed stopped
    while kill -0 $pid > /dev/null 2>&1; do
        wait
    done
}

asyncRun exec "$@"
