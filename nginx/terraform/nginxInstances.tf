## NGINX Instances Terraform

# Random uuid generator
resource "random_uuid" "nginx-random-uuid" {
  count = sum([var.nginx-api-gw-count, var.nginx-instance-count])
}

# Data of an existing subnet
data "azurerm_subnet" "existing" {
  name                 = var.existing_internal_subnet_name
  virtual_network_name = var.existing_subnet_vnet
  resource_group_name  = var.existing_subnet_resource_group
}

################################# NGINX API Gateway Instance Group #################################

# NGINX API Gateway NICs
resource "azurerm_network_interface" "nic-api-gw" {
  name                = "nic-${random_uuid.nginx-random-uuid[0].result}-${count.index}"
  location            = azurerm_resource_group.nginx-resource-group.location
  resource_group_name = azurerm_resource_group.nginx-resource-group.name
  count               = sum([var.nginx-api-gw-count])

  ip_configuration {
    name                          = "if-config"
    subnet_id                     = data.azurerm_subnet.existing.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    owner       = var.tag_owner
  }
}

# NGINX API Gateway Instances
resource "azurerm_virtual_machine" "nginx-api-gw" {
  name                             = "nginx-${random_uuid.nginx-random-uuid[0].result}-${count.index}"
  location                         = azurerm_resource_group.nginx-resource-group.location
  resource_group_name              = azurerm_resource_group.nginx-resource-group.name
  network_interface_ids            = [azurerm_network_interface.nic-api-gw[count.index].id]
  vm_size                          = "Standard_B1s"
  delete_data_disks_on_termination = true
  delete_os_disk_on_termination    = true
  availability_set_id              = azurerm_availability_set.nginx-api-gateway-instance.id
  count                            = sum([var.nginx-api-gw-count])

  # az vm image list -p nginxinc --all -f nginx_plus_with_nginx_app_protect_developer -s debian
  plan {
    publisher = "nginxinc"
    product   = var.nginx-api-gw-offer
    name      = var.nginx-api-gw-sku
  }

  storage_image_reference {
    publisher = "nginxinc"
    offer     = var.nginx-api-gw-offer
    sku       = var.nginx-api-gw-sku
    version   = var.nginx-api-gw-version
  }

  storage_os_disk {
    name              = "os-disk-${random_uuid.nginx-random-uuid[0].result}-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "nginx-${random_uuid.nginx-random-uuid[0].result}-${count.index}"
    admin_username = var.nginx_username
    admin_password = var.nginx_password
    custom_data    = base64encode(data.template_file.bootstrap-instance-group-api-gw.rendered)
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    owner       = var.tag_owner
    proxy       = "apigw"
  }
}

# NGINX API Gateway Instances bootstrapping file
data "template_file" "bootstrap-instance-group-api-gw" {
  template = file("${path.module}/files/bootstrap-instance-group-api-gw.sh")
}

## Availability Set
resource "azurerm_availability_set" "nginx-api-gateway-instance" {
  name                = "aset-api-gateway-${random_uuid.nginx-random-uuid[0].result}"
  location            = var.location
  resource_group_name = azurerm_resource_group.nginx-resource-group.name

  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    owner       = var.tag_owner
  }
}

# NGINX API Gateway Instances Shutdown Schedule
resource "azurerm_dev_test_global_vm_shutdown_schedule" "instance-group-api" {
  virtual_machine_id    = azurerm_virtual_machine.nginx-api-gw[count.index].id
  location              = var.location
  enabled               = true
  daily_recurrence_time = "1900"
  timezone              = "Pacific Standard Time"
  count                 = sum([var.nginx-api-gw-count])

  notification_settings {
    enabled         = true
    time_in_minutes = "30"
    email           = var.notification_email
  }
}

################################# NGINX Azure Instance Group #################################

# NGINX Instances NICs
resource "azurerm_network_interface" "nic-instances" {
  name                = "nic-${random_uuid.nginx-random-uuid[1].result}-${count.index}"
  location            = azurerm_resource_group.nginx-resource-group.location
  resource_group_name = azurerm_resource_group.nginx-resource-group.name
  count               = sum([var.nginx-instance-count])

  ip_configuration {
    name                          = "if-config"
    subnet_id                     = data.azurerm_subnet.existing.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    owner       = var.tag_owner
  }
}

# NGINX Instances
resource "azurerm_virtual_machine" "nginx-instance" {
  name                             = "nginx-${random_uuid.nginx-random-uuid[1].result}-${count.index}"
  location                         = azurerm_resource_group.nginx-resource-group.location
  resource_group_name              = azurerm_resource_group.nginx-resource-group.name
  network_interface_ids            = [azurerm_network_interface.nic-instances[count.index].id]
  vm_size                          = "Standard_B1s"
  delete_data_disks_on_termination = true
  delete_os_disk_on_termination    = true
  availability_set_id              = azurerm_availability_set.nginx-proxy-instance.id
  count                            = sum([var.nginx-instance-count])

  # az vm image list -p nginxinc --all -f nginx_plus_with_nginx_app_protect_developer -s debian
  plan {
    publisher = "nginxinc"
    product   = var.nginx-instance-offer
    name      = var.nginx-instance-sku
  }

  storage_image_reference {
    publisher = "nginxinc"
    offer     = var.nginx-instance-offer
    sku       = var.nginx-instance-sku
    version   = var.nginx-instance-version
  }

  storage_os_disk {
    name              = "os-disk-${random_uuid.nginx-random-uuid[1].result}-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "nginx-${random_uuid.nginx-random-uuid[1].result}-${count.index}"
    admin_username = var.nginx_username
    admin_password = var.nginx_password
    custom_data    = base64encode(data.template_file.bootstrap-instance-group-azure-instances.rendered)
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    owner       = var.tag_owner
    proxy       = "proxy"
  }
}

# NGINX Instances bootstrapping file
data "template_file" "bootstrap-instance-group-azure-instances" {
  template = file("${path.module}/files/bootstrap-instance-group-azure-instances.sh")
}

## Availability Set
resource "azurerm_availability_set" "nginx-proxy-instance" {
  name                = "aset-proxy-${random_uuid.nginx-random-uuid[1].result}"
  location            = var.location
  resource_group_name = azurerm_resource_group.nginx-resource-group.name

  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    owner       = var.tag_owner
  }
}

# NGINX Instances Shutdown Schedule
resource "azurerm_dev_test_global_vm_shutdown_schedule" "instance-group-azure-instances" {
  virtual_machine_id    = azurerm_virtual_machine.nginx-instance[count.index].id
  location              = var.location
  enabled               = true
  daily_recurrence_time = "1900"
  timezone              = "Pacific Standard Time"
  count                 = sum([var.nginx-instance-count])

  notification_settings {
    enabled         = true
    time_in_minutes = "30"
    email           = var.notification_email
  }
}