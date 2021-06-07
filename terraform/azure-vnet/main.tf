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
  Subnets = csvdecode(var.SUBNET_LIST)
  SubnetNames = [for d in local.Subnets: d.name]
  IdName = var.TARGET_SUBNET != "default" ? var.TARGET_SUBNET : element(local.SubnetNames,1)
}

resource "azurerm_network_security_group" "no_public" {
  name                = "${var.VNET_NAME}-no_public_terraform_NSG"
  location            = var.LOCATION
  resource_group_name = var.RESOURCE_GROUP_NAME

    security_rule {
    name                       = "block_all_in"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_virtual_network" "default" {
  name                = var.VNET_NAME
  location            = var.LOCATION
  resource_group_name = var.RESOURCE_GROUP_NAME
  address_space       = [var.VNET_ADDRESS_SPACE]
}

resource "azurerm_subnet" "default" {
  for_each = { for inst in local.Subnets : inst.name => inst }
  name                 = each.key
  resource_group_name  = var.RESOURCE_GROUP_NAME
  virtual_network_name = var.VNET_NAME
  address_prefixes     = ["${each.value.IP}/${each.value.CIDR}"]
  depends_on = [ azurerm_virtual_network.default ]
}

output NAME {
  value = azurerm_virtual_network.default.name
}
output GUID {
  value = azurerm_virtual_network.default.guid
}
output SUBNET_ID {
  value = azurerm_subnet.default[local.IdName].id
}
