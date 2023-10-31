helm uninstall hive-metastore presto minio

helm repo add minio https://charts.min.io/

helm install minio --set resources.requests.memory=512Mi --set replicas=1 --set persistence.enabled=false --set mode=standalone --set rootUser=presto,rootPassword=presto00 --set consoleService.type=NodePort --set environment.MINIO_BROWSER_LOGIN_ANIMATION=off minio/minio --set service.type=NodePort

curl -o ./mc.exe https://dl.min.io/client/mc/release/windows-amd64/mc.exe

git config --global core.autocrlf false

.\mc.exe --version

.\mc.exe alias set presto-nyc-meetup http://localhost:32000 presto presto00

.\mc.exe mb presto-nyc-meetup/presto-nyc-bucket 

.\mc.exe cp --recursive .\parquet\ presto-nyc-meetup/presto-nyc-bucket/parquet

mkdir ..\presto-demo

cd ..\presto-demo

git clone https://github.com/srameshdenodo/helm-hive-metastore

Set-NetFirewallProfile -Profile Public -DisabledInterfaceAliases "vEthernet (WSL)"

cd helm-hive-metastore\docker 

docker build -t hive-metastore:latest .

cd ..

helm install hive-metastore .

cd ..

docker pull ahanaio/prestodb-sandbox:0.283

git clone https://github.com/srameshdenodo/presto-helm-charts

cd presto-helm-charts/charts/presto

helm install presto .

kubectl get pods -w
