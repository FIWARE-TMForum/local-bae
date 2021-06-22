# Local BAE instance

Deploying local BAE instance with docker compose. Components are run in separate steps in order to 
be able to wait for components coming up, since docker compose dow not allow to depend on healthy 
containers.

This setup uses an external IDP. 



## Steps

### Initialize
Create the docker network and necessary directories for persistent storage of data:
```shell
make init
```
This only needs to be run once, or if you cleaned the setup with `make clean` before.


### Deploy databases
```shell
cd ./db
docker compose up -d
```
Check that elasticsearch, MySQL and MongoDB are up and running with `docker logs mp-XXX` (check container names 
in `docker-compose.yml`).


### Deploy APIs
```shell
cd ./apis
docker compose up -d
```
Check that APIs container is up and running with `docker logs mp-apis`. Wait until deployment has finished


### Deploy RSS
```shell
cd ./rss
docker compose up -d
```
Check that RSS container is up and running with `docker logs mp-rss`. Wait until deployment has finished


### Deploy Charging Backend and Logic Proxy
Create a file `charging-proxy/proxy.env` and set the following content, where you fill in (in case of 
using OAuth2 with an external Keyrock instance as IDP):

* URL of the external IDP
* BAE_LP_OAUTH2_CALLBACK: Callback URL of logic proxy
* ClientId and ClientSecret of the external IDPs application

```text
BAE_LP_OAUTH2_SERVER=<URL>
BAE_LP_OAUTH2_CALLBACK=http://localhost:8004/auth/fiware/callback
BAE_LP_OAUTH2_CLIENT_ID=<ClientId>
BAE_LP_OAUTH2_CLIENT_SECRET=<ClientSecret>
```
In the case that the external IDP is not Keyrock, then you also need to provide the ENV 
`BAE_LP_OAUTH2_PROVIDER` and maybe additional variables in this file. Also the callback 
URI needs to be adopted for the different strategy.

Now start the charging backend and logic proxy:
```shell
cd ./charging-proxy
docker compose up -d
```
Check that charging and proxy containers are up and running with `docker logs mp-charging`/`docker logs mp-proxy`. 
The indexing of the logic proxy takes some time.

Don't worry about the `401 Unauthorized` error when the charging backend is starting and trying to connect to the RSS 
API, this is ok!

Open the BAE marketplace [page](http://localhost:8004). Login with a user that has been configured in the 
external IDP.


## Shutdown

Run the following in each of the directories above:
```shell
docker compose down
```

**Optional**: In order to remove the network and directories created before, run
```shell
make clean
```
**Note**: This will delete all persistently stored content in the created directories!



## Problem solving

### Network not found
When starting a container and there appears an error 
like `Error response from daemon: network cdf0e4ed2876b14ee201a2243a5df96ba62527f85fd9c0b2615f43beae8d8e81 not found`, 
there might be still an existing container referring to the deleted network. 

You need to check for still existing BAE containers (prefix: `mp-`), that have not been deleted and are in `Exited` state:
```shell
docker container ls -a
```

Delete these containers:
```shell
docker container rm <CONTAINER-ID>
```
