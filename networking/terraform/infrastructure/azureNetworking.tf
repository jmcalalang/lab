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
  address_prefixes     = ["10.0.4.0/22"]
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
resource "azurerm_subnet_network_security_group_association" "management-nsg-association" {
  subnet_id                 = azurerm_subnet.management.id
  network_security_group_id = azurerm_network_security_group.management-nsg.id
}
resource "azurerm_network_security_group" "external-nsg" {
  name                = "external-nsg"
  location            = azurerm_resource_group.networking-resource-group.location
  resource_group_name = azurerm_resource_group.networking-resource-group.name
  security_rule {
    name                       = "ce-ui"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "65500"
    source_address_prefixes    = tolist([var.allowed_ips])
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "web-https"
    priority                   = 105
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefixes    = tolist([var.allowed_ips])
    destination_address_prefix = "*"
  }
  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }
}
resource "azurerm_subnet_network_security_group_association" "external-nsg-association" {
  subnet_id                 = azurerm_subnet.external.id
  network_security_group_id = azurerm_network_security_group.external-nsg.id
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
resource "azurerm_subnet_network_security_group_association" "internal-nsg-association" {
  subnet_id                 = azurerm_subnet.internal.id
  network_security_group_id = azurerm_network_security_group.internal-nsg.id
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
resource "azurerm_subnet_network_security_group_association" "kubernetes-nsg-association" {
  subnet_id                 = azurerm_subnet.kubernetes.id
  network_security_group_id = azurerm_network_security_group.kubernetes-nsg.id
}

## Azure Internal Subnet Nat Gateway
resource "azurerm_nat_gateway" "internal-ng" {
  name                = "internal-ng"
  location            = azurerm_resource_group.networking-resource-group.location
  resource_group_name = azurerm_resource_group.networking-resource-group.name
  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }
}
resource "azurerm_public_ip" "internal-ng-pip" {
  name                = "internal-ng-pip"
  location            = azurerm_resource_group.networking-resource-group.location
  resource_group_name = azurerm_resource_group.networking-resource-group.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }
}
resource "azurerm_nat_gateway_public_ip_association" "internal-ng" {
  nat_gateway_id       = azurerm_nat_gateway.internal-ng.id
  public_ip_address_id = azurerm_public_ip.internal-ng-pip.id
}
resource "azurerm_subnet_nat_gateway_association" "internal-ng" {
  subnet_id      = azurerm_subnet.internal.id
  nat_gateway_id = azurerm_nat_gateway.internal-ng.id
}

## Azure External Subnet Nat Gateway
resource "azurerm_nat_gateway" "external-ng" {
  name                = "external-ng"
  location            = azurerm_resource_group.networking-resource-group.location
  resource_group_name = azurerm_resource_group.networking-resource-group.name
  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }
}
resource "azurerm_public_ip" "external-ng-pip" {
  name                = "external-ng-pip"
  location            = azurerm_resource_group.networking-resource-group.location
  resource_group_name = azurerm_resource_group.networking-resource-group.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }
}
resource "azurerm_nat_gateway_public_ip_association" "external-ng" {
  nat_gateway_id       = azurerm_nat_gateway.external-ng.id
  public_ip_address_id = azurerm_public_ip.external-ng-pip.id
}
resource "azurerm_subnet_nat_gateway_association" "external-ng" {
  subnet_id      = azurerm_subnet.external.id
  nat_gateway_id = azurerm_nat_gateway.external-ng.id
}
