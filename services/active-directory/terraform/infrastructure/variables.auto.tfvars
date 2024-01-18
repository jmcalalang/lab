# Azure variables

location                       = "westus2"
resource_group_name            = "calalang-active-directory-rg"
tag_owner                      = "j.calalang@f5.com"
tag_resource_type              = "active-directory"
tag_environment                = "lab"
notification_email             = "j.calalang@f5.com"
existing_internal_subnet_name  = "internal"
existing_external_subnet_name  = "external"
existing_mgmt_subnet_name      = "management"
existing_subnet_vnet           = "azure-10-0-0-0-16-vnet"
existing_subnet_resource_group = "calalang-networking-rg"

# Active Directory variables

# az vm image list -p microsoftwindowsserver --all -f windowsserver -s 2022-datacenter-azure-edition-core-smalldisk
# az vm image accept-terms --urn microsoftwindowsserver:windowsserver:2022-datacenter-azure-edition-core-smalldisk:20348.2227.240104

active-directory-instance-offer     = "windowsserver"
active-directory-instance-publisher = "microsoftwindowsserver"
active-directory-instance-sku       = "2022-datacenter-azure-edition-core-smalldisk"
active-directory-instance-version   = "20348.2227.240104"
active-directory-instance-count     = 1
