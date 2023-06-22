# nginx instance management scratch

docker load -i nms-apigw-2.11.0.tar.gz
docker load -i nms-core-2.11.0.tar.gz
docker load -i nms-ingestion-2.11.0.tar.gz
docker load -i nms-dpm-2.11.0.tar.gz
docker load -i nms-integrations-2.11.0.tar.gz

docker load -i nms-acm-1.6.0-img.tar.gz

az acr login -n acri9eee8x9V --expose-token
docker login acri9eee8x9V.azurecr.io -u 00000000-0000-0000-0000-000000000000 -p accessToken

docker tag localhost/nms-apigw:2.11.0 acri9eee8x9V.azurecr.io/nms-apigw:2.11.0
docker tag localhost/nms-core:2.11.0 acri9eee8x9V.azurecr.io/nms-core:2.11.0
docker tag localhost/nms-dpm:2.11.0 acri9eee8x9V.azurecr.io/nms-dpm:2.11.0
docker tag localhost/nms-ingestion:2.11.0 acri9eee8x9V.azurecr.io/nms-ingestion:2.11.0
docker tag localhost/nms-integrations:2.11.0 acri9eee8x9V.azurecr.io/nms-integrations:2.11.0
docker tag localhost/nms-acm:1.6.0 acri9eee8x9V.azurecr.io/nms-acm:1.6.0

docker push acri9eee8x9V.azurecr.io/nms-apigw:2.11.0
docker push acri9eee8x9V.azurecr.io/nms-core:2.11.0
docker push acri9eee8x9V.azurecr.io/nms-dpm:2.11.0
docker push acri9eee8x9V.azurecr.io/nms-ingestion:2.11.0
docker push acri9eee8x9V.azurecr.io/nms-integrations:2.11.0
docker push acri9eee8x9V.azurecr.io/nms-acm:1.6.0

From Instance:
curl -k https://10.0.5.246/install/nginx-agent | sudo sh -s -- --skip-verify true --instance-group azure-instances
