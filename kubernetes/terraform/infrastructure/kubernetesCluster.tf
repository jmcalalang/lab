data "azurerm_subscription" "primary" {
}

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
    name           = "d3v2"
    node_count     = var.aks-node-count
    max_pods       = 250
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

resource "azurerm_role_definition" "aks-role-definition" {
  name        = "aks-role-${random_uuid.aks-random-uuid[0].result}"
  scope       = data.azurerm_subscription.primary.id
  description = "Role created for AKS clusters"

  permissions {
    actions = [
      "Microsoft.Network/virtualNetworks/subnets/joinLoadBalancer/action",
      "Microsoft.Network/virtualNetworks/subnets/read",
      "Microsoft.Network/virtualNetworks/subnets/join/action",
      "Microsoft.ContainerRegistry/registries/pull/read"
    ]
    not_actions = []
  }

  assignable_scopes = [
    data.azurerm_subscription.primary.id,
    data.azurerm_subnet.existing-subnet-kubernetes.id,
    "${data.azurerm_subscription.primary.id}/resourceGroups/${var.existing_subnet_resource_group}"
  ]
}

resource "azurerm_role_assignment" "aks-role-assignment" {
  principal_id                     = azurerm_kubernetes_cluster.kubernetes_cluster[count.index].kubelet_identity[0].object_id
  role_definition_name             = azurerm_role_definition.aks-role-definition.name
  scope                            = data.azurerm_subscription.primary.id
  skip_service_principal_aad_check = true
  count                            = sum([var.aks-instance-count])
}