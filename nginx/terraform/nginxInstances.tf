## NGINX Instances Terraform

# Random instance uuid generator
resource "random_uuid" "instances" {
}

# Data of an existing subnet
data "azurerm_subnet" "existing" {
  name                 = var.existing_subnet_name
  virtual_network_name = var.existing_subnet_vnet
  resource_group_name  = var.existing_subnet_resource_group
}

# NIC 
resource "azurerm_network_interface" "nic" {
  name                = "${random_uuid.instances.result}-nic"
  location            = azurerm_resource_group.nginx-resource-group.location
  resource_group_name = azurerm_resource_group.nginx-resource-group.name

  ip_configuration {
    name                          = "if-config"
    subnet_id                     = data.azurerm_subnet.existing.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    owner = var.tag_owner
  }
}

# Instance
resource "azurerm_virtual_machine" "nginx" {
  name                  = "nginx-${random_uuid.instances.result}"
  location              = azurerm_resource_group.nginx-resource-group.location
  resource_group_name   = azurerm_resource_group.nginx-resource-group.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = "Standard_B1s"

  # az vm image list -p nginxinc --all -f nginx_plus_with_nginx_app_protect_developer -s debian
  plan {
    publisher = "nginxinc"
    product   = "nginx_plus_with_nginx_app_protect_developer"
    name      = "nginx_plus_with_nginx_app_protect_dev_debian10"
  }

  storage_image_reference {
    publisher = "nginxinc"
    offer     = "nginx_plus_with_nginx_app_protect_developer"
    sku       = "nginx_plus_with_nginx_app_protect_dev_debian10"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${random_uuid.instances.result}-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "nginx-${random_uuid.instances.result}"
    admin_username = var.nginx_username
    admin_password = var.nginx_password
    custom_data    = base64encode(data.template_file.bootstrap.rendered)
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    owner = var.tag_owner
  }
}

# Data template Bash bootstrapping file
data "template_file" "bootstrap" {
  template = file("${path.module}/files/bootstrap.sh")
}

# Shutdown Schedule
resource "azurerm_dev_test_global_vm_shutdown_schedule" "daily" {
  virtual_machine_id = azurerm_linux_virtual_machine.nginx.id
  location           = azurerm_resource_group.nginx-resource-group.name
  enabled            = true

  daily_recurrence_time = "1930"
  timezone              = "Pacific Standard Time"

  notification_settings {
    enabled         = true
    time_in_minutes = "30"
    email     = "j.calalang@f5.com"
  }
}