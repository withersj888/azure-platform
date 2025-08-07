# Application Insights Module - Outputs

output "id" {
  description = "ID of the Application Insights instance"
  value       = azurerm_application_insights.main.id
}

output "name" {
  description = "Name of the Application Insights instance"
  value       = azurerm_application_insights.main.name
}

output "instrumentation_key" {
  description = "Instrumentation key of the Application Insights instance"
  value       = azurerm_application_insights.main.instrumentation_key
  sensitive   = true
}

output "connection_string" {
  description = "Connection string of the Application Insights instance"
  value       = azurerm_application_insights.main.connection_string
  sensitive   = true
}

output "app_id" {
  description = "Application ID of the Application Insights instance"
  value       = azurerm_application_insights.main.app_id
}

output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.main.id
}

output "log_analytics_workspace_name" {
  description = "Name of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.main.name
}

output "action_group_id" {
  description = "ID of the monitoring action group"
  value       = azurerm_monitor_action_group.main.id
}