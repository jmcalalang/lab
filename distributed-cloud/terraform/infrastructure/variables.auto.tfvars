## F5XC Terraform Variable Values

# Shared variables
namespace           = "j-calalang"
label-email         = "j.calalang@f5.com"
label-owner         = "j-calalang"
label-resource-type = "f5xc"
label-environment   = "lab"

# F5XC k8s variables
mk8s-name   = "calalang-mk8s"
mk8s-domain = "mk8s.calalang.net"
vk8s-name   = "calalang-vk8s"

# F5XC Azure Site
f5xc-azure-site-latitude       = 44.0582
f5xc-azure-site-longitude      = 121.3153
f5xc-azure-site-resource-group = "calalang-f5xc-rg"
f5xc-azure-ce-site-offer       = "azure-byol-voltmesh"
f5xc-azure-combo-site-offer    = "azure-byol-voltstack-combo"
location                       = "westus2"
existing-vnet-resource-group   = "calalang-networking-rg"
existing-vnet                  = "azure-10-0-0-0-16-vnet"
existing-vnet-subnet           = "external"