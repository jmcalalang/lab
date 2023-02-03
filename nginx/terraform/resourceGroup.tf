## Resource Group for NGINX resources

resource "azurerm_resource_group" "nginx-resource-group" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    owner = var.tag_owner
  }

}