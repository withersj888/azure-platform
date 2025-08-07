# Azure Functions Module - Outputs

output "function_app_names" {
  description = "Names of the Function Apps"
  value = {
    user_service = azurerm_linux_function_app.user_service.name
    data_service = azurerm_linux_function_app.data_service.name
  }
}

output "function_app_ids" {
  description = "IDs of the Function Apps"
  value = {
    user_service = azurerm_linux_function_app.user_service.id
    data_service = azurerm_linux_function_app.data_service.id
  }
}

output "function_app_urls" {
  description = "URLs of the Function Apps"
  value = {
    user_service = "https://${azurerm_linux_function_app.user_service.default_hostname}"
    data_service = "https://${azurerm_linux_function_app.data_service.default_hostname}"
  }
}

output "function_app_hostnames" {
  description = "Default hostnames of the Function Apps"
  value = {
    user_service = azurerm_linux_function_app.user_service.default_hostname
    data_service = azurerm_linux_function_app.data_service.default_hostname
  }
}

output "function_app_principal_ids" {
  description = "Principal IDs of the Function Apps managed identities"
  value = {
    user_service = azurerm_linux_function_app.user_service.identity[0].principal_id
    data_service = azurerm_linux_function_app.data_service.identity[0].principal_id
  }
}

output "storage_account_name" {
  description = "Name of the storage account for Function Apps"
  value       = azurerm_storage_account.functions.name
}

output "service_plan_id" {
  description = "ID of the App Service Plan"
  value       = azurerm_service_plan.functions.id
}