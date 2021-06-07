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

locals {
  sizeMap = { 
    "SMALL" = "GP_Gen5_2",
    "MEDIUM" = "GP_GEN5_4",
    "LARGE" = "GP_GEN5_8",
    "EXTRA-LARGE" = "GP_GEN5_16",
    "S2" = "S2",
    "S3" = "S3",
    "S4" = "S4"
  }

  listOfIps = var.ALLOWED_IPS
  ipList = compact(split(",", var.ALLOWED_IPS))

  sanitizedRG = replace(var.RESOURCE_GROUP_NAME, "_", "") #Server Name cannot contain anything other than letters, numbers, and hyphens
  serverName = lower("${var.SERVER_NAME}-${local.sanitizedRG}")

  customTags = {
    "APPID" = var.APP_ID,
    "APPLICATION OWNER" = var.APP_OWNER,
    "APPLICATION NAME" = var.APP_NAME
  }
}

resource "azurerm_mssql_server" "default" {
  name                         = local.serverName
  resource_group_name          = var.RESOURCE_GROUP_NAME
  location                     = var.LOCATION
  version                      = "12.0"
  public_network_access_enabled = true
  administrator_login          = var.SERVER_USERNAME
  administrator_login_password = var.SERVER_PASSWORD
}

resource "azurerm_sql_firewall_rule" "ip_list" {
  for_each            = { for x in local.ipList : x => x }
  name                = "${each.key}-Requested-IP-Allowance"
  resource_group_name = var.RESOURCE_GROUP_NAME
  server_name         = azurerm_mssql_server.default.name
  start_ip_address    = each.key
  end_ip_address      = each.key
  depends_on = [ azurerm_mssql_server.default ]
}

resource "azurerm_sql_firewall_rule" "allow_azure_services" {
  name                = "AllowAzureServices"
  resource_group_name = var.RESOURCE_GROUP_NAME
  server_name         = azurerm_mssql_server.default.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
  depends_on = [ azurerm_mssql_server.default ]
}

resource "azurerm_mssql_database" "default" {
  name                = var.DB_NAME
  server_id           = azurerm_mssql_server.default.id
  sku_name            = lookup(local.sizeMap, upper(var.DB_SIZE), "GP_Gen5_2")
  create_mode         = "Default"
  collation           = var.COLLATION
  max_size_gb         = var.DB_STORAGE
  depends_on = [ azurerm_mssql_server.default ]

  short_term_retention_policy {
    retention_days = 35
  }
  
  tags = merge(local.customTags)
}

/* Commented out while we are deciding on proper password handling procedures
resource "random_password" "RO_PASSWORD" { 
  length = 24
  special = true
  override_special = "_%@"
  min_special = 1
  min_lower = 1
  min_upper = 1
  min_numeric = 1
}

resource "random_password" "RW_PASSWORD" { 
  length = 24
  special = true
  override_special = "_%@"
  min_special = 1
  min_lower = 1
  min_upper = 1
  min_numeric = 1
}

resource "random_password" "WO_PASSWORD" { 
  length = 24
  special = true
  override_special = "_%@"
  min_special = 1
  min_lower = 1
  min_upper = 1
  min_numeric = 1
}
*/

resource "null_resource" "addUsers" {
  depends_on = [ azurerm_mssql_database.default ]

  provisioner "local-exec" {
    on_failure = fail
    command = "chmod +x runSQLCMD.sh && ./runSQLCMD.sh"
    interpreter = ["/bin/bash", "-c"]

    environment = {
      FQDN = azurerm_mssql_server.default.fully_qualified_domain_name
      SERVER_USERNAME = var.SERVER_USERNAME
      SERVER_PASSWORD = var.SERVER_PASSWORD
      DB_NAME = var.DB_NAME
      DB_USER = var.DB_USERNAME
      DB_PASS = var.DB_PASSWORD
      RO_USER = "${var.APP_NAME}_RO"
      RW_USER = "${var.APP_NAME}_RW"
      WO_USER = "${var.APP_NAME}_WO"
      RO_PASS = var.RO_PASSWORD
      RW_PASS = var.RW_PASSWORD
      WO_PASS = var.WO_PASSWORD
    }
  }
}


output "DB_HOSTNAME" {
  value = azurerm_mssql_server.default.fully_qualified_domain_name
}
output "DB_USER" {
  value = var.DB_USERNAME
}
output "DB_NAME" {
  value = var.DB_NAME
}
