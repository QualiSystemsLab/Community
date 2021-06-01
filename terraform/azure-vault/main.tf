provider "azurerm" {
  version = "=2.9.0"
  features {}
}

data "azurerm_key_vault" "keyvault" {
  name                = var.KEYVAULT_NAME
  resource_group_name = var.KEYVAULT_RG
}

data "azurerm_key_vault_secret" "keyvault_get" {
  name         = var.SECRET_NAME
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

output "SECRET_VALUE"{
  value = data.azurerm_key_vault_secret.keyvault_get.value
  sensitive = true
}