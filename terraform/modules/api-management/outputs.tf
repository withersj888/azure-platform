# API Management Module - Outputs

output "id" {
  description = "ID of the API Management instance"
  value       = azurerm_api_management.main.id
}

output "name" {
  description = "Name of the API Management instance"
  value       = azurerm_api_management.main.name
}

output "gateway_url" {
  description = "Gateway URL of the API Management instance"
  value       = azurerm_api_management.main.gateway_url
}

output "management_api_url" {
  description = "Management API URL of the API Management instance"
  value       = azurerm_api_management.main.management_api_url
}

output "portal_url" {
  description = "Portal URL of the API Management instance"
  value       = azurerm_api_management.main.portal_url
}

output "developer_portal_url" {
  description = "Developer Portal URL of the API Management instance"
  value       = azurerm_api_management.main.developer_portal_url
}

output "public_ip_addresses" {
  description = "Public IP addresses of the API Management instance"
  value       = azurerm_api_management.main.public_ip_addresses
}

output "apis" {
  description = "Information about the APIs created"
  value = {
    user_service = {
      name = azurerm_api_management_api.user_service.name
      path = azurerm_api_management_api.user_service.path
    }
    data_service = {
      name = azurerm_api_management_api.data_service.name
      path = azurerm_api_management_api.data_service.path
    }
  }
}

output "product_id" {
  description = "ID of the API Management product"
  value       = azurerm_api_management_product.main.product_id
}