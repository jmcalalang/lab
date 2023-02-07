# NGINX Terraform Variable Values

nginx-instance-offer = "nginx_plus_with_nginx_app_protect_developer"
nginx-instance-sku   = "nginx_plus_with_nginx_app_protect_dev_ubuntu2004"
nginx-instance-count = 1

nginx-api-gw-offer = "nginx_plus_with_nginx_app_protect_developer"
nginx-api-gw-sku   = "nginx_plus_with_nginx_app_protect_dev_ubuntu2004"
nginx-api-gw-count = 1

location            = "westus2"
resource_group_name = "calalang-nginx-rg"
tag_owner           = "j.calalang@f5.com"

# Existing Subnet Variable Values

existing_subnet_name           = "internal"
existing_subnet_vnet           = "calalang-azure-vnet"
existing_subnet_resource_group = "calalang-rg"