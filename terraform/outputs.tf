data "azurerm_public_ip" "web-vm-ip-data" {
  name                = azurerm_public_ip.web-vm-public_ip.name
  resource_group_name = azurerm_resource_group.rg.name
}

output "web-vm_public_ip_address" {
  value = "${azurerm_linux_virtual_machine.web-vm.name}: ${data.azurerm_public_ip.web-vm-ip-data.ip_address}"
}