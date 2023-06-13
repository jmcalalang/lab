################################# Azure Networking #################################

## Azure Resource Group
resource "azurerm_resource_group" "networking-resource-group" {
  name     = var.resource_group_name
  location = var.azure_location
  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }
}

## Azure Virtual Network
resource "azurerm_virtual_network" "azure-10-0-0-0-16-vnet" {
  name                = "azure-10-0-0-0-16-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.networking-resource-group.location
  resource_group_name = azurerm_resource_group.networking-resource-group.name
  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }
}

## Azure Virtual Network Subnets
resource "azurerm_subnet" "management" {
  name                 = "management"
  resource_group_name  = azurerm_resource_group.networking-resource-group.name
  virtual_network_name = azurerm_virtual_network.azure-10-0-0-0-16-vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "external" {
  name                 = "external"
  resource_group_name  = azurerm_resource_group.networking-resource-group.name
  virtual_network_name = azurerm_virtual_network.azure-10-0-0-0-16-vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.networking-resource-group.name
  virtual_network_name = azurerm_virtual_network.azure-10-0-0-0-16-vnet.name
  address_prefixes     = ["10.0.3.0/24"]
}
resource "azurerm_subnet" "kubernetes" {
  name                 = "kubernetes"
  resource_group_name  = azurerm_resource_group.networking-resource-group.name
  virtual_network_name = azurerm_virtual_network.azure-10-0-0-0-16-vnet.name
  address_prefixes     = ["10.0.4.0/24"]
}

## Azure Network Security Groups
resource "azurerm_network_security_group" "management-nsg" {
  name                = "management-nsg"
  location            = azurerm_resource_group.networking-resource-group.location
  resource_group_name = azurerm_resource_group.networking-resource-group.name
  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }
}


resource "azurerm_network_security_group" "external-nsg" {
  name                = "external-nsg"
  location            = azurerm_resource_group.networking-resource-group.location
  resource_group_name = azurerm_resource_group.networking-resource-group.name
  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }
}

resource "azurerm_network_security_group" "internal-nsg" {
  name                = "internal-nsg"
  location            = azurerm_resource_group.networking-resource-group.location
  resource_group_name = azurerm_resource_group.networking-resource-group.name

  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }
}

resource "azurerm_network_security_group" "kubernetes-nsg" {
  name                = "kubernetes-nsg"
  location            = azurerm_resource_group.networking-resource-group.location
  resource_group_name = azurerm_resource_group.networking-resource-group.name

  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }
}

## Azure Network Route Table
resource "azurerm_route_table" "external-rt" {
  name                = "external-rt"
  location            = azurerm_resource_group.networking-resource-group.location
  resource_group_name = azurerm_resource_group.networking-resource-group.name

  route {
    name           = "default"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "Internet"
  }
}

resource "azurerm_subnet_route_table_association" "external-rt" {
  subnet_id      = azurerm_subnet.external.id
  route_table_id = azurerm_route_table.external-rt.id
}

## Azure Nat Gateway
resource "azurerm_nat_gateway" "internal-ng" {
  name                = "internal-ng"
  location            = azurerm_resource_group.networking-resource-group.location
  resource_group_name = azurerm_resource_group.networking-resource-group.name
}

resource "azurerm_public_ip" "internal-ng-pip" {
  name                = "internal-ng-pip"
  location            = azurerm_resource_group.networking-resource-group.location
  resource_group_name = azurerm_resource_group.networking-resource-group.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_nat_gateway_public_ip_association" "internal-ng" {
  nat_gateway_id       = azurerm_nat_gateway.internal-ng.id
  public_ip_address_id = azurerm_public_ip.internal-ng-pip.id
}

resource "azurerm_subnet_nat_gateway_association" "internal-ng" {
  subnet_id      = azurerm_subnet.internal.id
  nat_gateway_id = azurerm_nat_gateway.internal-ng.id
}