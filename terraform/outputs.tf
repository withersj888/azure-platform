# Output values for Azure Platform Terraform Configuration

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "Location of the resource group"
  value       = azurerm_resource_group.main.location
}

# Key Vault outputs
output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = module.key_vault.key_vault_name
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = module.key_vault.key_vault_uri
}

# Application Insights outputs
output "application_insights_name" {
  description = "Name of Application Insights"
  value       = module.application_insights.name
}

output "application_insights_instrumentation_key" {
  description = "Instrumentation key for Application Insights"
  value       = module.application_insights.instrumentation_key
  sensitive   = true
}

output "application_insights_connection_string" {
  description = "Connection string for Application Insights"
  value       = module.application_insights.connection_string
  sensitive   = true
}

# Cosmos DB outputs
output "cosmos_db_account_name" {
  description = "Name of the Cosmos DB account"
  value       = module.cosmos_db.account_name
}

output "cosmos_db_endpoint" {
  description = "Endpoint of the Cosmos DB account"
  value       = module.cosmos_db.endpoint
}

output "cosmos_db_database_name" {
  description = "Name of the Cosmos DB database"
  value       = module.cosmos_db.database_name
}

# Azure Functions outputs
output "function_app_names" {
  description = "Names of the Function Apps"
  value       = module.azure_functions.function_app_names
}

output "function_app_urls" {
  description = "URLs of the Function Apps"
  value       = module.azure_functions.function_app_urls
}

output "function_app_hostnames" {
  description = "Default hostnames of the Function Apps"
  value       = module.azure_functions.function_app_hostnames
}

# API Management outputs
output "api_management_name" {
  description = "Name of the API Management instance"
  value       = module.api_management.name
}

output "api_management_gateway_url" {
  description = "Gateway URL of the API Management instance"
  value       = module.api_management.gateway_url
}

output "api_management_management_api_url" {
  description = "Management API URL of the API Management instance"
  value       = module.api_management.management_api_url
}

output "api_management_portal_url" {
  description = "Portal URL of the API Management instance"
  value       = module.api_management.portal_url
}

# Environment and naming outputs
output "environment" {
  description = "Environment name"
  value       = local.environment
}

output "project_name" {
  description = "Project name"
  value       = local.project_name
}

output "resource_suffix" {
  description = "Random suffix used for resource naming"
  value       = random_string.suffix.result
}