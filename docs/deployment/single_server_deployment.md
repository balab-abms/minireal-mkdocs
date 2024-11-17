---
title: Deployment on Single Server
summary: Deatils for the Deployment of the SimReal system on a Single Server.
authors:
    - Duguma Yeshitla
date: 2024-11-06
---
# Deployment on Single Server
This section elaborates on how deploy the SimReal system onto a single server or High
Peformance Computer (HPC). 
---

## Requirements
Before getting on deploying the system, two main components are needed to be 
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


## Docker YAML file
Since this section targets deployment of all services onto a single server, then all
services can be put to one Docker YAML configuration file as shown below.

```yaml
version: '3.8'
services:
  SimReal:
    container_name: SimReal
    image: pazed/SimReal:latest
    restart: unless-stopped
    env_file:
      - .env_SimReal
      - .env_kafka
      - .env_postgres
    ports:
      - 8090:8090
    volumes:
      - ./data:/usr/src/app/data
      - ./SimReal_data:/usr/src/app/SimReal_data
    depends_on:
      - broker
      - postgres
    networks:
      - SimReal

  zookeeper:
    image: confluentinc/cp-zookeeper:7.3.1
    hostname: zookeeper
    container_name: zookeeper
    ports:
      - "2181:2181"
    environment:
      ZOOKEEPER_CLIENT_PORT: 2181
      ZOOKEEPER_TICK_TIME: 2000
    networks:
      - SimReal

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
      - .env_kafka
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
    networks:
      - SimReal

  postgres:
    container_name: postgres
    image: postgres
    env_file:
      - .env_postgres
    environment:
      PGDATA: /data/postgres
    volumes:
      - postgres:/data/postgres
      - ./init-db.sh:/docker-entrypoint-initdb.d/init-db.sh

    ports:
      - "5432:5432"
    networks:
      - SimReal
    restart: unless-stopped

networks:
  SimReal:
    driver: bridge

volumes:
  postgres:
```

Inorder to ensure communication among these services, setting the required enviroment
variables is essential. The next section explains how to set them up.

## Required Enviroment Variables
The SimReal system accepts the addresses of the PostGREs database and Kafka broker at runtime 
(deployment). The database and broker services also require configuration on how 
they accept requests and they are identified. For this reason the following enviroment variables
need to be defined in a file in the same directory as the Docker YAML file.

There are three enviroment variables:

* `.env_postgres` : used to specify the enviroment variables needed for the PostGREs & SimReal container.
```bash title=".env_postgres"
POSTGRES_USER=root
POSTGRES_PASSWORD=example_pwd
POSTGRES_MULTIPLE_DATABASES=auth,sim,SimReal
```
* `.env_kafka` : used to specify the enviroment variables needed for the Kafka & SimReal containers.
```bash title=".env_kafka"
KAFKA_ADDRESS=broker
```
* `.env_SimReal` : used to specify the enviroment variables needed for the SimReal continaer.
```bash title=".env_SimReal"
KAFKA_PORT=9092
POSTGRES_DB=SimReal
POSTGRES_ADDRESS=postgres
POSTGRES_PORT=5432
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

!!! note
    Since all the continaers are on the same docker network, the names of the services
    in the Docker YAML configuration can be used to identify thier location.


## Deployment
After placing the Docker YAML and envrioment variable files in the same directory, run the
following command to depoly all the services.

```bash
docker-compose up -d
```

Or in the recent Docker package this command is updated to:

```bash
docker compose up -d
```

## Finalizing deployment
Upon sucessfull deployment, navigate to `localhost:8090` or `<host_ip_address>:8090` to
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