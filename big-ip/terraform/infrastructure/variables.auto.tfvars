# Shared variables

tag_owner                      = "j.calalang@f5.com"
tag_resource_type              = "big-ip"
tag_environment                = "lab"
bigip_ready                    = "300s"
bigip_runtime_init_package_url = "https://cdn.f5.com/product/cloudsolutions/f5-bigip-runtime-init/v1.5.2/dist/f5-bigip-runtime-init-1.5.2-1.gz.run"

# AWS variables

existing_subnet_az1_management_id = "subnet-0fed20660405dcd29"
existing_subnet_az1_external_id   = "subnet-0de5ca824f855eb8e"
existing_subnet_az1_internal_id   = "subnet-0b73939eba6454afb"
existing_subnet_az2_management_id = "subnet-00a2b950ce003876e"
existing_subnet_az2_external_id   = "subnet-0b0bcb1bf3a2473c9"
existing_subnet_az2_internal_id   = "subnet-0c005a1b2511dcd6f"
vpc_id                            = "vpc-0bb527f5634f025fa"

# AWS BIG-IP variables

# aws ec2 describe-images --owners 679593333241 --filters "Name=name, Values=*BIGIP-16.1.3*PAYG*"
big_ip_ami                  = "F5 BIGIP-16* PAYG-Best Plus 25Mbps*"
big_ip_per_az_count         = 1
external_secondary_ip_count = 1
internal_secondary_ip_count = 0
instance_type               = "m5.xlarge"
key_name                    = "calalang_west2_key"

# Azure variables

azure_location                  = "westus2"
existing_subnet_management_name = "management"
existing_subnet_internal_name   = "internal"
existing_subnet_external_name   = "external"
existing_subnet_vnet            = "azure-10-0-0-0-16-vnet"
existing_subnet_resource_group  = "calalang-networking-rg"
notification_email              = "j.calalang@f5.com"
resource_group_name             = "calalang-bigip-rg"

# Azure BIG-IP variables

big-ip-instance-count = 1
big-ip-instance-offer = "f5-big-ip-best"
big-ip-instance-size  = "Standard_DS3_v2"
# az vm image list -p f5-networks --all -f f5-big-ip-best -s 1g-best-hourly
big-ip-instance-sku = "f5-bigip-virtual-edition-1g-best-hourly-po-f5"
big-ip-version      = "16.1.304000"