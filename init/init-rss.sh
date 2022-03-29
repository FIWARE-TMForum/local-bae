#!/bin/bash

# Wait parameters
MAX_RETRIES=60
INTERVAL=5

# Wait for MySQL
while ! mysqladmin ping -hbae-mysql.docker -P 3306 --silent;
do
    echo "Waiting for MySQL"; ((i++)) && ((i==${MAX_RETRIES})) && break; sleep ${INTERVAL};
done;

# Wait for TMForum APIs
while ! wget -q "http://bae-apis.docker:8080/DSProductInventory";
do
    echo "Waiting for TMForum APIs (Inventory)"; ((i++)) && ((i==${MAX_RETRIES})) && break; sleep ${INTERVAL};
done;
while ! wget -q "http://bae-apis.docker:8080/DSProductCatalog";
do
    echo "Waiting for TMForum APIs (Catalog)"; ((i++)) && ((i==${MAX_RETRIES})) && break; sleep ${INTERVAL};
done;
while ! wget -q "http://bae-apis.docker:8080/DSProductOrdering";
do
    echo "Waiting for TMForum APIs (Ordering)"; ((i++)) && ((i==${MAX_RETRIES})) && break; sleep ${INTERVAL};
done;
while ! wget -q "http://bae-apis.docker:8080/DSPartyManagement";
do
    echo "Waiting for TMForum APIs (Party)"; ((i++)) && ((i==${MAX_RETRIES})) && break; sleep ${INTERVAL};
done;
while ! wget -q "http://bae-apis.docker:8080/DSBillingManagement";
do
    echo "Waiting for TMForum APIs (Billing)"; ((i++)) && ((i==${MAX_RETRIES})) && break; sleep ${INTERVAL};
done;
while ! wget -q "http://bae-apis.docker:8080/DSCustomerManagement";
do
    echo "Waiting for TMForum APIs (Customer)"; ((i++)) && ((i==${MAX_RETRIES})) && break; sleep ${INTERVAL};
done;
while ! wget -q "http://bae-apis.docker:8080/DSUsageManagement";
do
    echo "Waiting for TMForum APIs (Usage)"; ((i++)) && ((i==${MAX_RETRIES})) && break; sleep ${INTERVAL};
done;

# Start RSS
echo "Starting RSS"
/entrypoint.sh
