terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.34.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = var.state_resource_group_name
    storage_account_name = var.state_storage_account_name
    container_name       = "statefile01" # change to your container name
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  name                = "vnet-${var.prefix}"
  address_space       = var.vnetAdressSpace
}

resource "azurerm_subnet" "subnets" {
  for_each             = var.subnets
  name                 = each.value.name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = each.value.address
}

resource "azurerm_virtual_machine" "vm" {
  name                          = "vm-${var.prefix}"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.rg.name
  network_interface_ids         = [azurerm_network_interface.nic.id]
  vm_size                       = "Standard_DS1_v2"
  delete_os_disk_on_termination = true
  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-g2"
    version   = "latest"
  }
  storage_os_disk {
    name              = "osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "host01"
    admin_username = "testadmin"
    admin_password = data.azurerm_key_vault_secret.admin-pw.value
  }
  os_profile_windows_config {
    provision_vm_agent = true
  }
}