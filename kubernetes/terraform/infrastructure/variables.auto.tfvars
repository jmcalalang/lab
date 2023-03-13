# Azure variables

location                        = "westus2"
resource_group_name             = "calalang-aks-rg"
tag_owner                       = "j.calalang@f5.com"
tag_resource_type               = "kubernetes"
tag_environment                 = "lab"
existing_subnet_kubernetes_name = "kubernetes"
existing_subnet_vnet            = "calalang-azure-vnet"
existing_subnet_resource_group  = "calalang-rg"

# Kubernetes variables

aks-instance-count = 1
aks-node-count     = 2