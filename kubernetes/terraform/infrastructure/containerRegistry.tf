resource "random_string" "acr-random-string" {
  length      = 9
  lower       = true
  special     = false
  min_lower   = 3
  min_numeric = 3
}
resource "azurerm_container_registry" "container_registry" {
  name                = "acr${random_string.acr-random-string.result}"
  resource_group_name = azurerm_resource_group.kubernetes-resource-group.name
  location            = azurerm_resource_group.kubernetes-resource-group.location
  sku                 = "Premium"

  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    owner       = var.tag_owner
  }
}