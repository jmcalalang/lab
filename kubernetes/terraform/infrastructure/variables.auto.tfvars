# Azure variables

location                        = "westus2"
resource_group_name             = "calalang-aks-rg"
tag_owner                       = "j.calalang@f5.com"
tag_resource_type               = "kubernetes"
tag_environment                 = "lab"
existing_subnet_kubernetes_name = "kubernetes"
existing_subnet_vnet            = "azure-10-0-0-0-16-vnet"
existing_subnet_resource_group  = "calalang-networking-rg"

# Kubernetes variables

aks-instance-count = 1
aks-node-count     = 2
kubernetes_version = "1.26"
vm_size            = "Standard_D3_v2"