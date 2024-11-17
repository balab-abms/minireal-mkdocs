---
title: Distributed Deployment
summary: Details for the Deployment of the SimReal system in a distributed manner.
authors:
    - Duguma Yeshitla
date: 2024-11-06
---
# Distributed Deployment
This section elaborates on how deploy the SimReal system onto many servers in a distributed
manner.
---

## Requirements
Before getting on deploying the system two main components are needed to be 
installed on the server.

*   Docker
*   Java JDK (>= 17)


## Components
The components of the system required for the full functionality of SimReal are:

* [The SimReal Webservice system docker image](https://hub.docker.com/r/pazed/SimReal)
* [A PostGREs database docker image](https://hub.docker.com/_/postgres)
* [An Apache Kafka broker docker image](https://hub.docker.com/r/confluentinc/cp-server)
* [Zookeeper service docker image to initialize Kafka broker](https://hub.docker.com/r/confluentinc/cp-zookeeper)


The order in which the components should be started is:

1. PostGREs and Zookeeper container 
2. Kafka broker container
3. Once all the above services are confirmed to run then the SimReal container can be started.


## Deploying Database service
The PostGREs database contianer can be deployed separately on any server
that is accessable to the SimReal Service. The Docker YAML and enviroment variable files
should be placed in the same directory and thier contents are shared below.

```yaml title="docker-compose.yml"
version: '3.8'

services:
  postgres:
    container_name: postgres
    image: postgres
    environment:
      POSTGRES_USER: root
      POSTGRES_PASSWORD: simrealdb
      POSTGRES_MULTIPLE_DATABASES: auth, sim, SimReal
      PGDATA: /data/postgres
    volumes:
      - postgres:/data/postgres
      - ./init-db.sh:/docker-entrypoint-initdb.d/init-db.sh

    ports:
      - "5432:5432"
    networks:
      - postgres
    restart: unless-stopped

networks:
  postgres:
    driver: bridge

volumes:
  postgres:
  pgadmin:

```

```bash title=".env_postgres"
POSTGRES_USER=root
POSTGRES_PASSWORD=example_pwd
POSTGRES_MULTIPLE_DATABASES=auth,sim,SimReal
```

Additionally the PostGREs service also requires a startup bash script be placed with the Docker
compose file inorder to initialized the required databases for the SimReal system. The script is
named `init-db.sh` as shown below.

```bash title="init-db.sh"
#!/bin/bash
set -e

# Create multiple databases
for db in ${POSTGRES_MULTIPLE_DATABASES//,/ }; do
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
        CREATE DATABASE $db;
EOSQL
done
```

## Deploying Message Broker service
The Apache Kafka Message broker also can be deployed on a separate server that can be accessed
by the SimReal system. The Zookeeper and Kafka broker services, however, should be deployed
together on the same server. The Docker compose YAML and enviroment variable files are shared below.

```yaml title="docker-compose.yml"
version: '3.8'
services:
  zookeeper:
    image: confluentinc/cp-zookeeper:7.3.1
    hostname: zookeeper
    container_name: zookeeper
    ports:
      - "2181:2181"
    environment:
      ZOOKEEPER_CLIENT_PORT: 2181
      ZOOKEEPER_TICK_TIME: 2000

  broker:
    image: confluentinc/cp-server:7.3.1
    hostname: broker
    container_name: broker
    depends_on:
      - zookeeper
    ports:
      - "9092:9092"
      - "9101:9101"
    env_file:
          - .env
    environment:
      KAFKA_BROKER_ID: 1
      KAFKA_ZOOKEEPER_CONNECT: 'zookeeper:2181'
      KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://broker:29092,PLAINTEXT_HOST://${KAFKA_ADDRESS}:9092
      KAFKA_METRIC_REPORTERS: io.confluent.metrics.reporter.ConfluentMetricsReporter
      KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 1
      KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS: 0
      KAFKA_CONFLUENT_LICENSE_TOPIC_REPLICATION_FACTOR: 1
      KAFKA_CONFLUENT_BALANCER_TOPIC_REPLICATION_FACTOR: 1
      KAFKA_TRANSACTION_STATE_LOG_MIN_ISR: 1
      KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR: 1
      KAFKA_JMX_PORT: 9101
      KAFKA_JMX_HOSTNAME: localhost
      KAFKA_CONFLUENT_SCHEMA_REGISTRY_URL: http://schema-registry:8081
      CONFLUENT_METRICS_REPORTER_BOOTSTRAP_SERVERS: broker:29092
      CONFLUENT_METRICS_REPORTER_TOPIC_REPLICAS: 1
      CONFLUENT_METRICS_ENABLE: 'true'
      CONFLUENT_SUPPORT_CUSTOMER_ID: 'anonymous'
```

```bash title=".env_kafka"
KAFKA_ADDRESS=<IP_address_of_server>
```

## Deploying SimReal service
Once the Database and Message Broker services are up and running on their respective
server, the SimReal System can be deployed on a computer that can access both of the
aforementioned services. Here the `ip` or `domain-name` of the pre-requisite services
should be used for a propoer integration with them.

The content of the Docker compose and enviroment variables files for the SimReal System 
is shared below. 

```yaml title="docker-compose.yml"
version: '3.8'
services:
  SimReal:
    container_name: SimReal
    image: pazed/SimReal:latest
    restart: unless-stopped
    env_file:
      - .env
    ports:
      - 8090:8090
    volumes:
      - ./data:/usr/src/app/data
      - ./SimReal_data:/usr/src/app/SimReal_data
```

```bash title=".env_SimReal"
POSTGRES_ADDRESS=<IP_or_domain_of_db>
POSTGRES_PORT=5432
POSTGRES_USER=<db_user_name>
POSTGRES_PASSWORD=<db_password>
POSTGRES_DB=SimReal
KAFKA_ADDRESS=<IP_or_domain_of_broker>
KAFKA_PORT=9092
```

## Docker contianers deployment
After placing the Docker YAML and envrioment variable files in the same directory, run the
following command to depoly the respective services.

```bash
docker-compose up -d
```

Or in the recent Docker package this command is updated to:

```bash
docker compose up -d
```

## Finalizing deployment
Upon sucessfull deployment, navigate to `<SimReal_ip_address>:8090` to
obtain the login screen to the SimReal system.

![SimReal Login Screen](../imgs/login_page.png){ align=center }

Following the initial deployment one user with the `OWNER` privilage will be created. The
credentialis for this user are:

* username: `owner`
* password: `changemepwd`

!!! warning
    After logging in for the first time, make sure to change the password of this user.
    Its adviced to create another user with the role of `ADMIN` for the excuting the 
    operations of system management.