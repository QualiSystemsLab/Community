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
    "small" = "GP_Gen5_2",
    "medium" = "GP_GEN5_4",
    "large" = "GP_GEN5_8",
    "extra-large" = "GP_GEN5_16"
  }

  listOfIps = var.ALLOWED_IPS
  ipList = compact(split(",", var.ALLOWED_IPS))

    customTags = {
    "APPID" = var.APP_ID,
    "APPLICATION OWNER" = var.APP_OWNER,
    "APPLICATION NAME" = var.APP_NAME
  }
  sanitizedRG = replace(var.RESOURCE_GROUP_NAME, "_", "") #Server Name cannot contain anything other than letters, numbers, and hyphens
  serverName = lower("${var.SERVER_NAME}-${local.sanitizedRG}")
}

resource "azurerm_postgresql_server" "default" {
  name                         = local.serverName
  resource_group_name          = var.RESOURCE_GROUP_NAME
  location                     = var.LOCATION
  sku_name                     = lookup(local.sizeMap, var.DB_SIZE, "small")
  storage_mb                   = var.DB_STORAGE * 1024 // We are asking for this value in GB, but must provide MB to terraform
  version                      = "11"
  public_network_access_enabled = true
  administrator_login          = var.SERVER_USERNAME
  administrator_login_password = var.SERVER_PASSWORD
  backup_retention_days        = 35
  ssl_enforcement_enabled      = false
  tags                         = merge(local.customTags)
}

resource "azurerm_postgresql_firewall_rule" "ip_list" {
  for_each            = { for x in local.ipList : x => x }
  name                = replace("${each.key}-Access-Rule", ".", "-")
  resource_group_name = var.RESOURCE_GROUP_NAME
  server_name         = azurerm_postgresql_server.default.name
  start_ip_address    = each.key
  end_ip_address      = each.key
  depends_on = [ azurerm_postgresql_server.default ]
}

resource "azurerm_postgresql_firewall_rule" "allow_azure_services" {
  name                = "AllowAzureServices"
  resource_group_name = var.RESOURCE_GROUP_NAME
  server_name         = azurerm_postgresql_server.default.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
  depends_on          = [ azurerm_postgresql_server.default ]
}
resource "azurerm_postgresql_database" "default" {
  name                = var.DB_NAME
  resource_group_name = var.RESOURCE_GROUP_NAME
  server_name         = azurerm_postgresql_server.default.name
  collation           = var.COLLATION
  charset             = var.CHARSET
  depends_on          = [ azurerm_postgresql_server.default ]
  
}

resource "null_resource" "addUsers" {
  depends_on = [ azurerm_postgresql_database.default ]

  provisioner "local-exec" {
    on_failure = fail
    command = "chmod +x runPsql.sh && ./runPsql.sh"
    interpreter = ["/bin/bash", "-c"]

    environment = {
      FQDN = azurerm_postgresql_server.default.fqdn
      SERVER_USERNAME = var.SERVER_USERNAME
      SERVER_PASSWORD = var.SERVER_PASSWORD
      DB_NAME = var.DB_NAME
      DB_USER = var.DB_USERNAME
      DB_PASSWORD = var.DB_PASSWORD      
      RO_USER = "${var.APP_NAME}_RO"
      RW_USER = "${var.APP_NAME}_RW"
      O_USER = "${var.APP_NAME}_O"
      RO_PASS = var.RO_PASSWORD
      RW_PASS = var.RW_PASSWORD
      O_PASS = var.O_PASSWORD
    }
  }
}

output "DB_HOSTNAME" {
  value = azurerm_postgresql_server.default.fqdn
}
output "DB_USER" {
  value = var.DB_USERNAME
}