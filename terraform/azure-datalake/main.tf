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

resource "azurerm_data_lake_store" "default" {
  name                = var.DATALAKE_NAME
  resource_group_name = var.RESOURCE_GROUP_NAME
  location            = var.LOCATION
  firewall_allow_azure_ips = "Enabled"

}

output "DATALAKE_ENDPOINT" {
  value = azurerm_data_lake_store.default.endpoint
 }
 output "DATALAKE_NAME" {
   value = azurerm_data_lake_store.default.name
 }