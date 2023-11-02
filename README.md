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

2. Git clone https://github.com/srameshdenodo/presto-nyc-meetup 
3. Open command prompt or powershell with elevated permissions. Navigate into the folder and run .\install-presto-with-minio.bat . 

The script will deploy minio, hive-metastore and presto (1 coordinator and 2 worker nodes). It also moves the Parquet file to the minio bucket - presto-nyc-bucket

4. Using DBeaver, create a new PrestoDB connection with the following details:
Host: localhost
Port: 30400
Database/Schema: hive
Username: presto


5. Create a date_dim table using:
CREATE TABLE hive."default".date_dim (
d_date_sk bigint,
d_date_id varchar,
d_date date,
d_month_seq integer,
d_week_seq integer,
d_quarter_seq integer,
d_year integer,
d_dow integer,
d_moy integer,
d_dom integer,
d_qoy integer,
d_fy_year integer,
d_fy_quarter_seq integer,
d_fy_week_seq integer,
d_day_name varchar,
d_quarter_name varchar,
d_holiday varchar,
d_weekend varchar,
d_following_holiday varchar,
d_first_dom integer,
d_last_dom integer,
d_same_day_ly integer,
d_same_day_lq integer,
d_current_day varchar,
d_current_week varchar,
d_current_month varchar,
d_current_quarter varchar,
d_current_year varchar
)
WITH (
format = 'Parquet',
external_location = 's3a://presto-nyc-bucket/parquet/tpcds_1.date_dim'
);
