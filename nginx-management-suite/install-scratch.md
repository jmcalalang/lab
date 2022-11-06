# nginx instance management scratch

docker load -i nms-apigw-2.5.1.tar.gz
docker load -i nms-core-2.5.1.tar.gz  
docker load -i nms-ingestion-2.5.1.tar.gz
docker load -i nms-dpm-2.5.1.tar.gz
docker load -i nms-integrations-2.5.1.tar.gz

docker tag nginxdevopssvcs.azurecr.io/indigo-tools-docker/platform/release-2-5-1/apigw:latest calalangacr.azurecr.io/nms-apigw:2.5.1
docker tag nginxdevopssvcs.azurecr.io/indigo-tools-docker/platform/release-2-5-1/core:latest calalangacr.azurecr.io/nms-core:2.5.1
docker tag nginxdevopssvcs.azurecr.io/indigo-tools-docker/platform/release-2-5-1/dpm:latest calalangacr.azurecr.io/nms-dpm:2.5.1
docker tag nginxdevopssvcs.azurecr.io/indigo-tools-docker/platform/release-2-5-1/ingestion:latest calalangacr.azurecr.io/nms-ingestion:2.5.1
docker tag nginxdevopssvcs.azurecr.io/indigo-tools-docker/platform/release-2-5-1/integrations:latest calalangacr.azurecr.io/nms-integrations:2.5.1

az login
az acr login --name calalangacr

docker push calalangacr.azurecr.io/nms-apigw:2.5.1
docker push calalangacr.azurecr.io/nms-core:2.5.1
docker push calalangacr.azurecr.io/nms-dpm:2.5.1
docker push calalangacr.azurecr.io/nms-ingestion:2.5.1
docker push calalangacr.azurecr.io/nms-integrations:2.5.1

tar -xzf nms-hybrid-2.5.1.tgz   

helm install --create-namespace --namespace nms --dry-run nim ./nms-hybrid

curl -k https://10.0.4.54/install/nginx-agent | sudo sh -s -- --skip-verify false --instance-group azure-instances
