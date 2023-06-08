## F5XC Terraform Variable Values

# Shared variables
namespace           = "j-calalang"
label-email         = "j.calalang@f5.com"
label-owner         = "j-calalang"
label-resource-type = "f5xc"
label-environment   = "lab"

# F5XC vk8s variables
vk8s-name = "calalang-vk8s"

# F5XC Azure Site
f5xc-azure-site-latitude       = 44.0582
f5xc-azure-site-longitude      = 121.3153
f5xc-azure-site-resource-group = "calalang-f5xc-rg"
f5xc-azure-site-offer          = "azure-byol-voltstack-combo" # Mesh azure-byol-voltmesh, Stack azure-byol-voltstack-combo
location                       = "westus2"
existing-vnet-resource-group   = "calalang-rg"
existing-vnet                  = "calalang-azure-vnet"
existing-vnet-subnet           = "external"