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


resource "azuread_application" "service_application" {
  display_name                       =  var.DISPLAY_NAME
  homepage                   = "http://quali.com"
  available_to_other_tenants = false
  oauth2_allow_implicit_flow = true
}


resource "azuread_service_principal" "principal" {
  application_id               = azuread_application.service_application.application_id
  app_role_assignment_required = false

  tags = ["Colony", "CycleCloud"]
}

resource "azuread_service_principal_password" "service_application" {
  service_principal_id = azuread_service_principal.principal.application_id
  description = "Password created in Colony via Terraform"
  value                = var.PASSWORD
  end_date             = "2040-01-01T01:02:03Z" 
}

output "PRINCIPAL_OATH2" {
  description = "OATH2 info - admin_consent_description, admin_consent_display_name, id, is_enable, type, user_content_description, user_content_display_name, value"
  value = azuread_service_principal.principal.oauth2_permissions
}

output "PRINCIPAL_ID" {
  value = azuread_service_principal.principal.object_id
}

output "APPLICATION_ID" {
  value = azuread_application.service_application.application_id
}