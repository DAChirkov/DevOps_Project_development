variable "resource_group_location" {}
variable "resource_group_name" {}
variable "subnet_id" {}
variable "network_security_group_id" {}
variable "public_key" {}

variable "vms_size" {
  default     = "Standard_B1ls"
  description = "Size for VMs"
}
variable "image_reference" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    publisher = "Debian"
    offer     = "Debian-11"
    sku       = "11"
    version   = "latest"
  }
}
variable "storage_os_disk" {
  type = object({
    caching           = string
    managed_disk_type = string
  })
  default = {
    caching           = "ReadWrite"
    managed_disk_type = "Standard_LRS"
  }
}
variable "os_profile" {
  type        = string
  default     = "azroot"
  description = "Name of admin username"
}

variable "manage_prefix" {
  default     = "vm-mng-1"
  description = "Management server prefix"
}
