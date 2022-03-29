#! /bin/bash

# Wait parameters
MAX_RETRIES=60
INTERVAL=10

# Check if key/cert content is set as ENV and export to separate key/cert file
if [ -n "$BAE_TOKEN_KEY_CONTENT" ]; then
    echo "Private key content found as ENV, exporting to /run/secrets/key.pem"
    echo "${BAE_TOKEN_KEY_CONTENT}" > /run/secrets/key.pem
    echo "Overwriting ENV BAE_TOKEN_KEY with /run/secrets/key.pem"
    export BAE_TOKEN_KEY="/run/secrets/key.pem"
fi
if [ -n "$BAE_TOKEN_CRT_CONTENT" ]; then
    echo "Certificate content found as ENV, exporting to /run/secrets/crt.pem"
    echo "${BAE_TOKEN_CRT_CONTENT}" > /run/secrets/crt.pem
    echo "Overwriting ENV BAE_TOKEN_CRT with /run/secrets/crt.pem"
    export BAE_TOKEN_CRT="/run/secrets/crt.pem"
fi

# Wait for Mongo
# --> No mongo client in container
#while ! mongo --host bae-mongo.docker --eval "printjson(db.serverStatus())";
#do
#    echo "Waiting for MongoDB"; ((i++)) && ((i==${MAX_RETRIES})) && break; sleep ${INTERVAL};
#done;

# Wait for elasticsearch
while ! curl --silent --fail bae-elasticsearch.docker:9200/_cluster/health;
do
    echo "Waiting for elasticsearch"; ((i++)) && ((i==${MAX_RETRIES})) && break; sleep ${INTERVAL};
done

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

# Wait for RSS


# Wait for charging Backend
while ! wget -q "http://bae-charging.docker:8006/charging/api/assetManagement/currencyCodes";
do
    echo "Waiting for Charging Backend"; ((i++)) && ((i==${MAX_RETRIES})) && break; sleep ${INTERVAL};
done;

# Start Logic Proxy
echo "Starting Logic Proxy"
/entrypoint.sh
