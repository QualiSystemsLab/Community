variable "SANDBOX_ID" {
  type = string
}

variable "HELM_REPO" {
  type        = string
  description = "Repository URL where to locate the requested chart"
  default     = ""
}

variable "HELM_CHART" {
  type        = string
  description = "Chart name to be installed"
  default     = ""
}

variable "HELM_NAMESPACE" {
  type        = string
  description = "The namespace to install the release into"
  default     = "default"
}

variable "HELM_REPO_PASSWORD" {
  type        = string
  sensitive   = true
  description = "Password for HTTP basic authentication against the repository"
  default     = ""
}

variable "HELM_VALUES" {
  type    = string
  default = ""
}

locals {
  helm_values           = split(";", var.HELM_VALUES)
  helm_config           = tomap({for x in local.helm_values : split(":",x)[0] => split(":",x)[1]})
  helm_chart_loc_length = length(split("/",var.HELM_CHART))
  helm_trim             = split("/",var.HELM_CHART)[local.helm_chart_loc_length - 1]
}