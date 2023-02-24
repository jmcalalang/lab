# Azure variables

location                       = "westus2"
resource_group_name            = "calalang-nginx-rg"
tag_owner                      = "j.calalang@f5.com"
tag_resource_type              = "nginx"
tag_environment                = "lab"
existing_internal_subnet_name  = "internal"
existing_external_subnet_name  = "external"
existing_mgmt_subnet_name      = "mgmt"
existing_subnet_vnet           = "calalang-azure-vnet"
existing_subnet_resource_group = "calalang-rg"

# NGINX variables

nginx-instance-offer = "nginx_plus_with_nginx_app_protect_developer"
nginx-instance-sku   = "nginx_plus_with_nginx_app_protect_dev_ubuntu2004"
nginx-instance-count = 1

nginx-api-gw-offer = "nginx_plus_with_nginx_app_protect_developer"
nginx-api-gw-sku   = "nginx_plus_with_nginx_app_protect_dev_ubuntu2004"
nginx-api-gw-count = 1