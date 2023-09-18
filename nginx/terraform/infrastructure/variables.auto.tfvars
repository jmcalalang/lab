# Azure variables

location                       = "westus2"
resource_group_name            = "calalang-nginx-rg"
tag_owner                      = "j.calalang@f5.com"
tag_resource_type              = "nginx"
tag_environment                = "lab"
notification_email             = "j.calalang@f5.com"
existing_internal_subnet_name  = "internal"
existing_external_subnet_name  = "external"
existing_mgmt_subnet_name      = "management"
existing_subnet_vnet           = "azure-10-0-0-0-16-vnet"
existing_subnet_resource_group = "calalang-networking-rg"

# NGINX variables

# az vm image list -p nginxinc --all -f nginx_plus_with_nginx_app_protect_developer -s nginx_plus_with_nginx_app_protect_dev_ubuntu2004

nms-hostname = "10.0.5.246"

nginx-instance-offer   = "nginx_plus_with_nginx_app_protect_developer"
nginx-instance-sku     = "nginx_plus_with_nginx_app_protect_dev_ubuntu2004"
nginx-instance-version = "6.1.0"
nginx-instance-count   = 1

nginx-api-gw-offer   = "nginx_plus_with_nginx_app_protect_developer"
nginx-api-gw-sku     = "nginx_plus_with_nginx_app_protect_dev_ubuntu2004"
nginx-api-gw-version = "6.1.0"
nginx-api-gw-count   = 2