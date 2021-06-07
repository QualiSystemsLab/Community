variable "LOCATION" {
}
variable "RESOURCE_GROUP_NAME" {
}
variable "VNET_NAME" {
}
variable "VNET_ADDRESS_SPACE" {
    description = "IP Range in CIDR Form"
    type = string
}
variable "TARGET_SUBNET" {
    description = "Subnet you want ID returned of, optional"
    type = string
    default = "default"
}
#List of Subnets in CSV Format
variable "SUBNET_LIST" {
    description = "List of subnets the vnet should contain in CSV format. At least one is required. Example: \n name,IP,CIDR \n subnet1,10.0.1.0,16 \n subnet2, 10.0.2.0,16 \n This makes a subnet named subnet1, 10.0.1.0/16 and subnet2, 10.0.2.0/16"
    type = string
    default = "name,IP,CIDR\ndefault,10.0.1.0,24"
}