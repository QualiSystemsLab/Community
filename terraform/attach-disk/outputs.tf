output "res_group_sandbox_id" {
  value = data.azurerm_resource_group.sandbox_rg.id
}

output "vm_id" {
  value = data.azurerm_virtual_machine.main.id
}
