resource "random_uuid" "aks-random-uuid" {
  count = sum([var.aks-instance-count])
}

data "azurerm_subnet" "existing-subnet-kubernetes" {
  name                 = var.existing_subnet_kubernetes_name
  virtual_network_name = var.existing_subnet_vnet
  resource_group_name  = var.existing_subnet_resource_group
}

resource "azurerm_kubernetes_cluster" "kubernetes_cluster" {
  name                = "aks-${random_uuid.aks-random-uuid[0].result}-${count.index}"
  location            = azurerm_resource_group.kubernetes-resource-group.location
  resource_group_name = azurerm_resource_group.kubernetes-resource-group.name
  dns_prefix          = "aks-${random_uuid.aks-random-uuid[0].result}-${count.index}"
  count               = sum([var.aks-instance-count])
  kubernetes_version  = "1.25.5"

  network_profile {
    network_plugin     = "azure"
    network_policy     = "calico"
    service_cidr       = "10.0.8.0/23"
    docker_bridge_cidr = "172.17.0.1/16"
    dns_service_ip     = "10.0.8.10"
  }

  default_node_pool {
    name       = "d2v2"
    node_count = 2
    #max_pods       = 100
    vm_size        = "Standard_D3_v2"
    vnet_subnet_id = data.azurerm_subnet.existing-subnet-kubernetes.id
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    owner       = var.tag_owner
  }
}