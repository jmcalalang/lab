data "azurerm_subscription" "primary" {
}

resource "azurerm_role_assignment" "AcrPull" {
  principal_id                     = azurerm_kubernetes_cluster.kubernetes_cluster[count.index].kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.container_registry.id
  skip_service_principal_aad_check = true
  count                            = sum([var.aks-instance-count])
}

resource "azurerm_role_assignment" "AKS-Internal-LB" {
  principal_id                     = azurerm_kubernetes_cluster.kubernetes_cluster[count.index].kubelet_identity[0].object_id
  role_definition_name             = "AKS-Internal-LB"
  scope                            = data.azurerm_subscription.primary.id
  skip_service_principal_aad_check = true
  count                            = sum([var.aks-instance-count])
}