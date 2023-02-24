## Resource Group for BIG-IP resources

resource "azurerm_resource_group" "big-ip-resource-group" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    owner       = var.tag_owner
  }

}