#!/bin/bash

# Wait for MySQL
MAX_RETRIES=60
INTERVAL=5
while ! mysqladmin ping -hbae-mysql.docker -P 3306 --silent;
do
    echo "Waiting for MySQL"; ((i++)) && ((i==${MAX_RETRIES})) && break; sleep ${INTERVAL};
done;

# Start TMForum APIs
echo "Starting TMForum APIs"
/entrypoint.sh
