variable "resource_group_location" {
  default     = "eastus2"
  description = "Location of the resource group"
}

variable "resource_group_name" {
  default     = "RG_AzProject_VMs_test-env"
  description = "Name of the resource group"
}

variable "resource_ssh_servers_key" {
  default     = "SSHKeysForServers_test-env"
  description = "Name of the SSH keys for manage servers"
}
variable "resource_ssh_servers_public_key" {
  type    = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDXI3Dz+WjsUjXlIAnHJ8Uii+HLpx/2JNXOUlRY6hpNgFfdJVbIC+iskhNDxDV39maur15W/ANa1yFBakUP6ysNQVG6V5Xfaex95tMmhRVPsGOqYarMN8cCLMeb6fLlm+JsNpEj3keSt5rl/rSsxndqNGMhbBKD1/CWqvOv2do6jwi3Z5NXuCXxSvksQFSFBjbP28SNSJpZGrq7Qc2cWv3s7baKsAUSpCv26kdQG+Ji1YrGrfkgnT6c023Xm1oaty4rbuoIakmAGE5Tx45t2uL+SANN+dMHYLZQoCYwJhwEWpoLMlefoGjdZ57c0aH5AKgixqIgElR+NpjiHd5Xgt15 Azure_Project_20230601"
}

variable "resource_virtual_network" {
  default     = "vNet-AzProject_test-env"
  description = "Name of the virtual network"
}
variable "resource_subnet1" {
  default     = "SubNet1-AzProject_test-env"
  description = "Name of the subnet 1"
}
variable "resource_nsg_main" {
  default     = "NSG-AzProject_test-env"
  description = "Name of the main NSG"
}

