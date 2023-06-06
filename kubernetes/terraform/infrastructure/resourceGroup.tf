## Resource Group for kubernetes resources

resource "azurerm_resource_group" "kubernetes-resource-group" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = "lab"
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }
}