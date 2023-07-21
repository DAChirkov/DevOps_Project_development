output "nic_id" {
  value = azurerm_network_interface.frontend_servers.*.id
}
