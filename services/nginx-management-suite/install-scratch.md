# nginx instance management scratch

docker load -i nms-apigw-2.8.0.tar.gz
docker load -i nms-core-2.8.0.tar.gz  
docker load -i nms-ingestion-2.8.0.tar.gz
docker load -i nms-dpm-2.8.0.tar.gz
docker load -i nms-integrations-2.8.0.tar.gz

docker tag localhost/nms-apigw:2.7.0 calalangacr.azurecr.io/nms-apigw:2.8.0
docker tag localhost/nms-core:2.8.0 calalangacr.azurecr.io/nms-core:2.8.0
docker tag localhost/nms-dpm:2.8.0 calalangacr.azurecr.io/nms-dpm:2.8.0
docker tag localhost/nms-ingestion:2.8.0 calalangacr.azurecr.io/nms-ingestion:2.8.0
docker tag localhost/nms-integrations:2.8.0 calalangacr.azurecr.io/nms-integrations:2.8.0
docker tag localhost/acm:1.4.0 calalangacr.azurecr.io/acm:1.4.0

docker login calalangacr.azurecr.io -u <username> -p <password>

docker push calalangacr.azurecr.io/nms-apigw:2.8.0
docker push calalangacr.azurecr.io/nms-core:2.8.0
docker push calalangacr.azurecr.io/nms-dpm:2.8.0
docker push calalangacr.azurecr.io/nms-ingestion:2.8.0
docker push calalangacr.azurecr.io/nms-integrations:2.8.0
docker push calalangacr.azurecr.io/acm:1.4.0


From Instance:
curl -k https://10.0.4.54/install/nginx-agent | sudo sh -s -- --skip-verify true --instance-group azure-instances