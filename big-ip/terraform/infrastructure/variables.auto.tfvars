# Azure variables

location                        = "westus2"
resource_group_name             = "calalang-bigip-terraform-rg"
tag_owner                       = "j.calalang@f5.com"
existing_subnet_management_name = "mgmt"
existing_subnet_internal_name   = "internal"
existing_subnet_external_name   = "external"
existing_subnet_vnet            = "calalang-azure-vnet"
existing_subnet_resource_group  = "calalang-rg"

# BIG-IP variables

big-ip-instance-offer = "f5-big-ip-best"
# az vm image list -p f5-networks --all -f f5-big-ip-best -s 1g-best-hourly
big-ip-instance-sku            = "f5-bigip-virtual-edition-1g-best-hourly-po-f5"
big-ip-version                 = "latest"
big-ip-instance-count          = 1
big-ip-instance-size           = "Standard_DS3_v2"
bigip_runtime_init_package_url = "https://cdn.f5.com/product/cloudsolutions/f5-bigip-runtime-init/v1.5.2/dist/f5-bigip-runtime-init-1.5.2-1.gz.run"
bigip_ready                    = "180s"