variable "STORAGE_ACCOUNT_NAME" {
}
variable "RESOURCE_GROUP_NAME" {
}
variable "LOCATION" {
}
variable "ACCOUNT_TIER" {
    description = "Standard or Premium"
    type = string
    default = "standard"
}
variable "ACCOUNT_REPLICATION" {
    description = "Data Replication (Redundancy) - LRS (Local), GRS (Global), ZRS (Zone), RA GRS, RA ZRS "
    type = string
    default = "LRS"
}
variable "CONTAINER_NAME" {
    default = "content"
}

