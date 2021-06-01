data "azurerm_resource_group" "sandbox_rg" {
  name = var.SANDBOX_ID
}

data "azurerm_virtual_machine" "main" {
  name                = var.VM_NAME
  resource_group_name = data.azurerm_resource_group.sandbox_rg.name
}