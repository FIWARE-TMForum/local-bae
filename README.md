# Deploying local instance of the Business API Ecosystem

Deploying local Business API Ecosystem (BAE) and Keyrock Identity Provider (IDP) 
instance with docker compose. 


## Remarks

The components reside in a docker network 'bae' created when using docker compose. 
Within this network, containers can communicate with each other. By default,
this network is used as external in order to allow communication with other
components deployed in docker, so it must exists in advance.

This setup can be used in two different ways. (1) By default it comes with a set
of aliases created in the docker network that can be used as hostnames for the
different components.

(2) On the other hand, fixed IPs for each container within the subnet `10.2.0.0/16`
can be used. To use such an approach, it is possible to uncomment network sections
in the docker-compose.yml file. Make sure that no IPs are already being used in this subnet.


## Deployment

The following describes how to configure and deploy the required containers for 
the databases:

* MySQL
* MongoDB
* elasticsearch

the Keyrock IDP and the containers for the different BAE components of:

* APIs
* RSS
* Charging Backend
* Logic Proxy

This setup comes with a default configuration for running a standard instance of the 
BAE. The Keyrock database is initialized with an application 'Marketplace' for the BAE 
in order to use this Keyrock instance as a local IDP for login at the BAE via OAuth2.

If using the aliases for communication it is needed to add them to the hosts file
of the host machine. This way the aliases can be used also as host names in the
local environment simplifying the login process.

Edit hosts file and include:
```
127.0.0.1 bae.docker idm.docker
```

The bae network is declared as external, so it must exists in advance.
```shell
docker network create bae
```

To deploy all components, simply run:
```shell
docker compose up -d
```

For stopping all containers:
```shell
docker compose down
```


### Configuration

Configuration is done via environment variables stored in the 
[.env](./.env) file and separate env files in the 
[envs/](./envs) directory. 


To change certain parameters, e.g., adding a configuration to participate in an i4Trust data space, 
make a copy of the default [.env](./.env) file
```shell
cp .env my.env
```
edit the `my.env` file according to your needs and then deploy all components with 
```shell
docker compose --env-file ./my.env up -d
```


## Usage


### BAE

As soon as the Logic Proxy component of the BAE (container name: 'bae-proxy') is healthy, 
you can open the marketplace start page 
on your host's browser by opening the URL: [http://bae.docker:8004](http://bae.docker:8004) or
[http://10.2.0.23:8004](http://10.2.0.23:8004) if you are using the fixed IPs.
Login is performed using the pre-configured Keyrock IDP. 
For a first test, hit the 'Sign in' button and
enter the admin credentials:
```
Username: admin@test.com
Password: admin
```
Authorize the Marketplace and then you are logged in as a user with admin priviliges on the BAE. 

Note, that when enabling external IDPs from an i4Trust data space, you might also enable showing the 
'Local Login' button with the ENV `BAE_LP_SHOW_LOCAL_LOGIN`, in order to be also able to use the locally 
configured Keyrock for login. If not, the local IDP can be used for login by directly entering
 [http://bae.docker:8004/login](http://bae.docker:8004/login) or
[http://10.2.0.23:8004/login](http://10.2.0.23:8004/login) if using IPs at the host's browser.



### Keyrock

You can also login directly at the Keyrock IDP by opening [http://idm.docker:8080](http://idm.docker:8080) or [http://10.2.0.10:8080](http://10.2.0.10:8080) if using IPs
within your browser and using the same admin credentials. When being logged in, you will find a pre-configured 
Application for the BAE (Marketplace). Within the Admin UI, you can add further users and authorize them for 
the BAE.

