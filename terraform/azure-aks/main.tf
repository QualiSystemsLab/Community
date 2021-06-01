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

module "azure-vnet" {
  count = var.newVnet ? 1 : 0
  source = "../azure-vnet"
  RESOURCE_GROUP_NAME = vars.RESOURCE_GROUP_NAME
  VNET_NAME = vars.VNET_NAME
  VNET_ADDRESS_SPACE = vars.VNET_ADDRESS_SPACE
  SUBNET_LIST = vars.SUBNET_LIST
  newResourceGroup = false
}

resource "azurerm_kubernetes_cluster" "default" {
  name                = var.CLUSTER_NAME
  location            = var.LOCATION
  resource_group_name = var.CLUSTER_NAME
  dns_prefix          = var.DNS_PREFIX
  sku_tier            = var.SKU_TIER

  default_node_pool {
    name       = var.NODE_POOL_NAME
    node_count = var.NODE_COUNT
    vm_size    = var.NODE_SIZE
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "default" {
    name                  = "user"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.default.id
  vm_size               = "Standard_DS2_v2"
  node_count            = 1
  vnet_subnet_id        = azurerm_subnet.internal.id
}

output "CLIENT_CERTIFICATE" {
  value = azurerm_kubernetes_cluster.default.kube_config.0.client_certificate
}

output "KUBE_CONFIG" {
  description = "Raw Kubernetes configuration for use with kubectl"
  value = azurerm_kubernetes_cluster.default.kube_config_raw
}

output "FQDN" {
  value = azurerm_kubernetes_cluster.default.FQDN
}