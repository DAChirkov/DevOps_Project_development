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
    key                  = "terraform_k8s.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = var.resource_group_name
}

resource "azurerm_kubernetes_cluster" "k8s" {
  depends_on          = [azurerm_resource_group.rg]
  name                = "${var.resource_cluster_k8s_name}-k8s"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.resource_cluster_k8s_name}-k8s"

  default_node_pool {
    name                  = "pool1"
    node_count            = 1
    vm_size               = "Standard_B2s"
    enable_auto_scaling   = true
    min_count             = 1
    max_count             = 2
    max_pods              = 30
    enable_node_public_ip = false
  }
  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
    outbound_type     = "loadBalancer"
  }
  identity {
    type = "SystemAssigned"
  }
}
