# presto-nyc-meetup
Provide files to setup a local Presto cluster with hive metastore and Minio object storage

The steps below help you to create a local cluster of Presto nodes running on your laptop.

**Pre-requisites:**

1. A Local PostgreSQL server running on your machine. This is to simplify not adding more pods and volumes that require persistance. In future, we will update this to include running PostgreSQL in containers as well so this setup can be run just with couple of scripts
2. This PostgreSQL should accept external connections. You can do this by modifying the <postgres_home>/data/pg_hba.conf. For example the following line:
TYPE  DATABASE        USER            ADDRESS                 METHOD
host    all             all             0.0.0.0/0            scram-sha-256
3. Create a user called 'hive' with password 'hive'. And a database 'metastore' with the owner being 'hive' user. 
4. A Kubernetes cluster. We are using [Rancher Desktop]([url](https://rancherdesktop.io/)https://rancherdesktop.io/) in this setup to setup the docker and kubernetes environment required for this demo

**Steps to run the demo:**

1. Run Rancher Desktop and modify the following
Under “File > Preferences > Container Engine > General” choose:
dockerd (moby)
Under “File > Preferences > WSL > Integrations” choose:
Ubuntu
Under “File > Preferences > Kubernetes” choose:
Enable Kubernetes

2. Add minio repo with the following command

helm repo add minio https://charts.min.io/

3. Deploy helm with

helm install minio --set resources.requests.memory=512Mi --set replicas=1 --set persistence.enabled=false --set mode=standalone --set rootUser=presto,rootPassword=presto00 --set consoleService.type=NodePort --set environment.MINIO_BROWSER_LOGIN_ANIMATION=off minio/minio

4. Access the minio console ast http://localhost:32001/ and log in with the credentials presto/prest00
5. Under ‘Buckets’ on the left hand side create bucket with the name ‘test’
6. Under ‘Object Browser > Test > Upload > Upload Folder’ add the prerequisite ‘parquet’ folder. The .dat file should be located under the path ‘test/parquet/tpcds_1.date_dim’

7. git clone the following repo

   https://github.com/srameshdenodo/helm-hive-metastore

   And run from helm-hive-metastore-main\docker

   docker build -t hive-metastore:latest .

8. Run the following to allow your pod to communicate through your firewall 

Set-NetFirewallProfile -Profile Public -DisabledInterfaceAliases "vEthernet (WSL)"

9. go back to helm-hive-metastore-main folder and run

   helm install hive-metastore . 

