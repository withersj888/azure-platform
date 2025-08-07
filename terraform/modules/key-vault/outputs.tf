# Key Vault Module - Outputs

output "key_vault_id" {
  description = "ID of the Key Vault"
  value       = azurerm_key_vault.main.id
}

output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = azurerm_key_vault.main.name
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = azurerm_key_vault.main.vault_uri
}

output "cosmos_db_connection_string_secret_id" {
  description = "Secret ID for Cosmos DB connection string"
  value       = azurerm_key_vault_secret.cosmos_db_connection_string.id
}

output "application_insights_connection_string_secret_id" {
  description = "Secret ID for Application Insights connection string"
  value       = azurerm_key_vault_secret.application_insights_connection_string.id
}

output "application_insights_instrumentation_key_secret_id" {
  description = "Secret ID for Application Insights instrumentation key"
  value       = azurerm_key_vault_secret.application_insights_instrumentation_key.id
}