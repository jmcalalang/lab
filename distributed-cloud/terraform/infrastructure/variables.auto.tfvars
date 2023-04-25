## F5XC Terraform Variable Values

# Shared variables
namespace           = "j-calalang"
label-owner         = "j-calalang"
label-resource-type = "f5xc"
label-environment   = "lab"

# F5XC vk8s variables
vk8s-name = "calalang-vk8s"

# F5XC Azure Site
f5xc-azure-site-count          = 1
f5xc-azure-site-latitude       = 44.0582
f5xc-azure-site-longitude      = 121.3153
f5xc-azure-site-resource-group = "calalang-f5xc-rg"
f5xc-azure-site-offer          = "azure-byol-voltmesh"
location                       = "westus2"
existing-vnet-resource-group   = "calalang-rg"
existing-vnet-subnet           = "external"