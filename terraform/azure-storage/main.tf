terraform {
  required_providers {
    azurerm = {
      version = "2.40"
    }
  }
}

provider azurerm {
  features {}
}
resource "azurerm_storage_account" "default" {
  name                     = var.STORAGE_ACCOUNT_NAME
  resource_group_name      = var.RESOURCE_GROUP_NAME
  location                 = var.LOCATION
  account_tier             = var.ACCOUNT_TIER
  account_replication_type = var.ACCOUNT_REPLICATION
}

resource "azurerm_storage_container" "default" {
  name                  = var.CONTAINER_NAME
  storage_account_name  = var.STORAGE_ACCOUNT_NAME
  container_access_type = "private"
  depends_on = [ azurerm_storage_account.default ]
}

output "STORAGE_ACCOUNT_NAME" {
  value = azurerm_storage_account.default.name
}
output "STORAGE_ACCOUNT_ENDPOINT" {
  value = azurerm_storage_account.default.primary_blob_endpoint
}
