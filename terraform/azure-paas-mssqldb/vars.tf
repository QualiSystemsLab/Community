variable "RESOURCE_GROUP_NAME" {
    type = string
}
variable "LOCATION" {
    type = string
}
variable "SERVER_NAME" {
    type = string
}
variable "SERVER_USERNAME" {
}
variable "SERVER_PASSWORD" {
}
variable "DB_NAME" {
}
variable "DB_USERNAME" {
}
variable "DB_PASSWORD" {
    sensitive = true
}

variable "DB_SIZE" {
    description = "Desired Service Level - small (2 v-core) , medium (4), or large (8)"
    default = "SMALL"
    type = string

    validation {
        condition = contains(["SMALL", "MEDIUM", "LARGE", "S3", "S4", "S2"], upper(var.DB_SIZE))
        error_message = "Valid Values: small, medium, large."
    }
}

variable "DB_STORAGE" {
    type = number
    default = 50
}

variable "ALLOWED_IPS" {
    description = "List of IPs to be allowed, comma-separated. Example: 192.168.1.1,192.168.1.20,192.168.1.222"
    type = string
}

variable "COLLATION" {
    default = "SQL_LATIN1_GENERAL_CP1_CI_AS"
    type = string
}

variable "RO_PASSWORD" {
    type = string
}
variable "RW_PASSWORD" {
    type = string
}
variable "WO_PASSWORD" {
    type = string
}

#TAGS
variable "APP_ID" {
}
variable "APP_OWNER" {
}
variable "APP_NAME" {
}

