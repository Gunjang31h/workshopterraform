terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "~>3.34.0"
    }
  }
  backend "azurerm" {
      resource_group_name  = "rg-gunnugupta1999" # change to your rg name
      storage_account_name = "backendstatestg" # change to your storage account name
      container_name       = "statefile01" # change to your container name
      key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-gunnugupta1999" # change to your rg name
  location = var.location
}
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.vnetAdressSpace
}
