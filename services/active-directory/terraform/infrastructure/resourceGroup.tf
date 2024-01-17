## Resource Group for NGINX resources

resource "azurerm_resource_group" "nginx-resource-group" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }

}
