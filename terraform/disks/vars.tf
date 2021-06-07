variable SANDBOX_ID {
  type = string
}

variable LOCATION {
  type = string
}

#################################
# Use caching  for attached disks
##################################
variable "caching" {
  type    = string
  default = "None"  
}

#############################
# Input virtual machine name
#############################
variable "vm1" {
  type    = string
  default = "staging-vm"   
}

variable "type_hdd" {
  type    = string
  default = "Standard_LRS"   
}

##############
# Disks types
##############
variable "type_ssd" {
  type    = string
  default = "StandardSSD_LRS"   
}

#############################
# Vars using for map creation
#############################
variable "input_disk_string" {}
variable "search"  { default = "/[[:digit:]]/" }
variable "search_ssd"  { default = "/(?i):SSD/" }
variable "replace" { default = "" }

################################
# Create map from input string
################################
locals {
  map = zipmap(split(",", replace(replace(var.input_disk_string, " ", ""), var.search_ssd, var.replace)), split(",", replace(replace(var.input_disk_string, " ", ""), var.search, var.replace)))
}