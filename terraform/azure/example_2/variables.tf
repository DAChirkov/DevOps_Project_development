variable "resource_group_location" {
  default     = "eastus2"
  description = "Location of the resource group"
}

variable "resource_group_name" {
  default     = "RG_AzProject_K8s"
  description = "Name of the resource group"
}

variable "resource_cluster_k8s_name" {
  default     = "azproject"
  description = "Name of the Cluster k8s"
}
