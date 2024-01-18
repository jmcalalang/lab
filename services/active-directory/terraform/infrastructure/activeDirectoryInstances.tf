## Active Directory Instances Terraform

# Random id generator
resource "random_string" "active-directory-random-string" {
  length      = 4
  min_lower   = 2
  min_numeric = 2
  special     = false
  upper       = false
  count       = sum([var.active-directory-instance-count])
}

# Data of an existing subnet
data "azurerm_subnet" "existing" {
  name                 = var.existing_internal_subnet_name
  virtual_network_name = var.existing_subnet_vnet
  resource_group_name  = var.existing_subnet_resource_group
}

################################# Active Directory Azure Instance Group #################################

# Active Directory Instance Security Groups

resource "azurerm_network_security_group" "active-directory-instances-sg" {
  name                = "active-directory-instances-sg"
  location            = azurerm_resource_group.active-directory-resource-group.location
  resource_group_name = azurerm_resource_group.active-directory-resource-group.name

  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }
}

resource "azurerm_network_interface_security_group_association" "active-directory-instances-sg" {
  network_interface_id      = azurerm_network_interface.nic-instances[count.index].id
  network_security_group_id = azurerm_network_security_group.active-directory-instances-sg.id
  count                     = sum([var.active-directory-instance-count])
}

# Active Directory Instances NICs
resource "azurerm_network_interface" "nic-instances" {
  name                = "nic-${random_string.active-directory-random-string[0].result}-${count.index}"
  location            = azurerm_resource_group.active-directory-resource-group.location
  resource_group_name = azurerm_resource_group.active-directory-resource-group.name
  count               = sum([var.active-directory-instance-count])

  ip_configuration {
    name                          = "if-config"
    subnet_id                     = data.azurerm_subnet.existing.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }
}

# Active Directory Instances
resource "azurerm_windows_virtual_machine" "active-directory-instance" {
  name                  = "win-${random_string.active-directory-random-string[0].result}-${count.index}"
  admin_username        = var.active-directory-username
  admin_password        = var.active-directory-password
  location              = azurerm_resource_group.active-directory-resource-group.location
  patch_mode            = "AutomaticByPlatform"
  hotpatching_enabled   = true
  resource_group_name   = azurerm_resource_group.active-directory-resource-group.name
  network_interface_ids = [azurerm_network_interface.nic-instances[count.index].id]
  size                  = "Standard_D2_v2"
  availability_set_id   = azurerm_availability_set.active-directory-instance.id
  count                 = sum([var.active-directory-instance-count])

  source_image_reference {
    publisher = var.active-directory-instance-publisher
    offer     = var.active-directory-instance-offer
    sku       = var.active-directory-instance-sku
    version   = var.active-directory-instance-version
  }

  os_disk {
    name                 = "os-disk-${random_string.active-directory-random-string[0].result}-${count.index}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }
}

## Availability Set
resource "azurerm_availability_set" "active-directory-instance" {
  name                = "a-set-${random_string.active-directory-random-string[0].result}"
  location            = var.location
  resource_group_name = azurerm_resource_group.active-directory-resource-group.name

  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    Owner       = var.tag_owner
  }
}

# Active Directory Instances Shutdown Schedule
resource "azurerm_dev_test_global_vm_shutdown_schedule" "instance-group-azure-instances" {
  virtual_machine_id    = azurerm_windows_virtual_machine.active-directory-instance[count.index].id
  location              = var.location
  enabled               = true
  daily_recurrence_time = "1900"
  timezone              = "Pacific Standard Time"
  count                 = sum([var.active-directory-instance-count])

  notification_settings {
    enabled         = true
    time_in_minutes = "30"
    email           = var.notification_email
  }
}
