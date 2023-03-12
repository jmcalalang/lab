# nginx instance management scratch

docker load -i nms-apigw-2.8.0.tar.gz
docker load -i nms-core-2.8.0.tar.gz  
docker load -i nms-ingestion-2.8.0.tar.gz
docker load -i nms-dpm-2.8.0.tar.gz
docker load -i nms-integrations-2.8.0.tar.gz
docker load -i nms-acm-1.4.1-img.tar.gz
docker load -i nms-acm-1.4.0-img.tar.gz

docker tag localhost/nms-apigw:2.8.0 acr402dut161.azurecr.io/nms-apigw:2.8.0
docker tag localhost/nms-core:2.8.0 acr402dut161.azurecr.io/nms-core:2.8.0
docker tag localhost/nms-dpm:2.8.0 acr402dut161.azurecr.io/nms-dpm:2.8.0
docker tag localhost/nms-ingestion:2.8.0 acr402dut161.azurecr.io/nms-ingestion:2.8.0
docker tag localhost/nms-integrations:2.8.0 acr402dut161.azurecr.io/nms-integrations:2.8.0
docker tag localhost/acm:1.4.1 acr402dut161.azurecr.io/nms-acm:1.4.1
docker tag localhost/acm:1.4.0 acr402dut161.azurecr.io/nms-acm:1.4.0


az acr login -n acr402dut161 --expose-token
docker login acr402dut161.azurecr.io -u 00000000-0000-0000-0000-000000000000 -p accessToken

docker push acr402dut161.azurecr.io/nms-apigw:2.8.0
docker push acr402dut161.azurecr.io/nms-core:2.8.0
docker push acr402dut161.azurecr.io/nms-dpm:2.8.0
docker push acr402dut161.azurecr.io/nms-ingestion:2.8.0
docker push acr402dut161.azurecr.io/nms-integrations:2.8.0
docker push acr402dut161.azurecr.io/nms-acm:1.4.1
docker push acr402dut161.azurecr.io/nms-acm:1.4.0


From Instance:
curl -k https://10.0.4.54/install/nginx-agent | sudo sh -s -- --skip-verify true --instance-group azure-instances