## Resource Group for BIG-IP resources

resource "azurerm_resource_group" "big-ip-resource-group" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = "lab"
    big-ip      = "instances"
    owner       = var.tag_owner
  }

}