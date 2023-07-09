terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.63.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "RG_AzProject"
    storage_account_name = "tfstate1748524386"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "existing" {
  name = var.resource_group_name
}

resource "azurerm_resource_group" "rg" {
  count    = data.azurerm_resource_group.existing ? 0 : 1
  location = var.resource_group_location
  name     = var.resource_group_name
}

###############################
#ADD SSH KEYS 
###############################

resource "azurerm_virtual_network" "vnet" {
  depends_on          = [data.azurerm_resource_group.existing]
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  name                = var.resource_virtual_network
  address_space       = ["10.1.0.0/16"]
}
resource "azurerm_subnet" "snet1" {
  depends_on           = [azurerm_virtual_network.vnet]
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.resource_virtual_network
  name                 = var.resource_subnet1
  address_prefixes     = ["10.1.0.0/24"]
}
resource "azurerm_subnet" "snet2" {
  depends_on           = [azurerm_virtual_network.vnet]
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.resource_virtual_network
  name                 = var.resource_subnet2
  address_prefixes     = ["10.1.1.0/24"]
}
resource "azurerm_subnet" "snet3" {
  depends_on           = [azurerm_virtual_network.vnet]
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.resource_virtual_network
  name                 = var.resource_subnet3
  address_prefixes     = ["10.1.2.0/24"]
}

resource "azurerm_network_security_group" "main-nsg" {
  depends_on          = [data.azurerm_resource_group.existing]
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  name                = var.resource_main-nsg
}
resource "azurerm_network_security_rule" "main-nsg-ssh" {
  depends_on                  = [azurerm_network_security_group.main-nsg]
  name                        = "SSH"
  resource_group_name         = var.resource_group_name
  network_security_group_name = var.resource_main-nsg
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "178.134.247.73"
  destination_address_prefix  = "10.1.0.4"
}
resource "azurerm_network_security_rule" "main-nsg-http" {
  depends_on                  = [azurerm_network_security_group.main-nsg]
  name                        = "SiteAllow_HTTP"
  resource_group_name         = var.resource_group_name
  network_security_group_name = var.resource_main-nsg
  priority                    = 999
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "10.1.1.0/24"
}
