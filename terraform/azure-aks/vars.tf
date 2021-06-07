variable "NODE_COUNT" {
    description = "Number of nodes to provision in AKS cluster"
    type = number
    default = 2
}
variable "CLUSTER_NAME" {
    description = "Name of AKS Cluster in Portal"
    type = string
}
variable "LOCATION" {
    type = string
}
variable "RESOURCE_GROUP_NAME" {
}
variable "SKU_TIER" {
    description = "Tier of Cluster - Paid or Free. Default Paid"
    type = string
    default = "Paid"
}
variable "DNS_PREFIX" {
    description = "Required for Terraform, used at front of generated FQDN for cluster"
    type = string
}
variable "NODE_POOL_NAME" {
    description = "Name of node pool"
    type = string
    default = "default"
}
variable "NODE_SIZE"{
    description = "VM Size to utilize for nodes in cluster"
    type = string
    default = "Standard_D2_v2"
}

variable "VNET_ADDRESS_SPACE" {
    description = "Address space of the VNET in CIDR format, only required if creating new VNET"
    type = string
    default = "0"
}

variable "SUBNET_LIST" {
    description = "Subnets to create in the new virtual network, leave empty if no new network created. Provided in CSV format - columns of Name,IP,CIDR"
    type = string
    default = "name,IP,CIDR\ndefault,10.0.1.0,24"
}

variable "SUBNET_ID" {
    description = "ID of subnet where to place node pool. Use name of subnet if creating a new one"
    type = string
    default = "default"
}
#Conditionals to set options

variable "newVnet" {
    default= true
    type= bool
    description = "Determine if we should create a new subnet or use an existing. True means new subnet"
}