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
variable "VM_NAME" {
  type    = string  
}

variable "DATA_STORAGE" {
  type = number
  default = 50
}

variable "LOG_STORAGE" {
  type = number
  default = 50
}

variable "TEMP_STORAGE" {
  type = number
  default = 50
}

variable "SYSTEM_STORAGE" {
  type = number
  default = 50
}
