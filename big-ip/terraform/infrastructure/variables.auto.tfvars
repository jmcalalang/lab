# Shared variables

bigip_ready                    = "300s"
tag_owner                      = "j.calalang@f5.com"
tag_resource_type              = "big-ip"
tag_environment                = "lab"
bigip_runtime_init_package_url = "https://cdn.f5.com/product/cloudsolutions/f5-bigip-runtime-init/v1.5.2/dist/f5-bigip-runtime-init-1.5.2-1.gz.run"

# AWS variables

allowed_ips                       = ["208.100.170.10/32"]
existing_subnet_az1_management_id = "subnet-0ee8e2cae6cea74cb"
existing_subnet_az1_external_id   = "subnet-06cab6de005ec9785"
existing_subnet_az1_internal_id   = "subnet-04c7cfb35c9224840"
existing_subnet_az2_management_id = "subnet-0a6fe8fde8d5b510a"
existing_subnet_az2_external_id   = "subnet-05b2a7b832d0e8217"
existing_subnet_az2_internal_id   = "subnet-0a3a131eabe6298e5"
vpc_id                            = "vpc-0f4d706f36f3387c0"

# AWS BIG-IP variables

big_ip_ami                  = "F5 BIGIP-16* PAYG-Best Plus 25Mbps*"
big_ip_per_az_count         = 1
external_secondary_ip_count = 1
internal_secondary_ip_count = 0
instance_type               = "m5.xlarge"
key_name                    = "calalang_west2_key"

# Azure variables

azure_location                  = "westus2"
existing_subnet_management_name = "mgmt"
existing_subnet_internal_name   = "internal"
existing_subnet_external_name   = "external"
existing_subnet_vnet            = "calalang-azure-vnet"
existing_subnet_resource_group  = "calalang-rg"
notification_email              = "j.calalang@f5.com"
resource_group_name             = "calalang-bigip-rg"

# Azure BIG-IP variables

big-ip-instance-count = 1
big-ip-instance-offer = "f5-big-ip-best"
big-ip-instance-size  = "Standard_DS3_v2"
# az vm image list -p f5-networks --all -f f5-big-ip-best -s 1g-best-hourly
big-ip-instance-sku = "f5-bigip-virtual-edition-1g-best-hourly-po-f5"
big-ip-version      = "16.1.303000"