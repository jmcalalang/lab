# NGINX Terraform Variable Values

object_count        = 2
location            = "westus2"
resource_group_name = "calalang-nginx-terraform-rg"
tag_owner           = "j.calalang@f5.com"

# Existing Subnet Variable Values

existing_subnet_name           = "internal"
existing_subnet_vnet           = "calalang-azure-vnet"
existing_subnet_resource_group = "calalang-rg"