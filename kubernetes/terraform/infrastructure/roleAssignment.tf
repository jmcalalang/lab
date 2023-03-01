resource "azurerm_role_assignment" "aks_role_assignment" {
  principal_id                     = azurerm_kubernetes_cluster.kubernetes_cluster[count.index].kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.container_registry.id
  skip_service_principal_aad_check = true
  count                            = sum([var.aks-instance-count])
}