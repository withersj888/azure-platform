# API Management Module - Main Configuration

# API Management instance
resource "azurerm_api_management" "main" {
  name                = "${var.project_name}-${var.environment}-apim-${var.suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  publisher_name      = "Azure Platform Team"
  publisher_email     = "platform@company.com"
  sku_name            = "Developer_1"

  tags = var.tags
}

# Logger for Application Insights
resource "azurerm_api_management_logger" "main" {
  name                = "applicationinsights"
  api_management_name = azurerm_api_management.main.name
  resource_group_name = var.resource_group_name

  application_insights {
    instrumentation_key = var.application_insights_id
  }
}

# API for User Service
resource "azurerm_api_management_api" "user_service" {
  name                = "user-service-api"
  resource_group_name = var.resource_group_name
  api_management_name = azurerm_api_management.main.name
  revision            = "1"
  display_name        = "User Service API"
  path                = "users"
  protocols           = ["https"]
  service_url         = var.function_app_urls.user_service

  import {
    content_format = "swagger-link-json"
    content_value  = "https://raw.githubusercontent.com/OAI/OpenAPI-Specification/master/examples/v2.0/json/petstore-expanded.json"
  }
}

# API for Data Service
resource "azurerm_api_management_api" "data_service" {
  name                = "data-service-api"
  resource_group_name = var.resource_group_name
  api_management_name = azurerm_api_management.main.name
  revision            = "1"
  display_name        = "Data Service API"
  path                = "data"
  protocols           = ["https"]
  service_url         = var.function_app_urls.data_service

  import {
    content_format = "swagger-link-json"
    content_value  = "https://raw.githubusercontent.com/OAI/OpenAPI-Specification/master/examples/v2.0/json/petstore-expanded.json"
  }
}

# Product for the APIs
resource "azurerm_api_management_product" "main" {
  product_id            = "azure-platform-apis"
  api_management_name   = azurerm_api_management.main.name
  resource_group_name   = var.resource_group_name
  display_name          = "Azure Platform APIs"
  description           = "APIs for the Azure Platform microservices"
  subscription_required = true
  approval_required     = true
  published             = true
}

# Associate User Service API with Product
resource "azurerm_api_management_product_api" "user_service" {
  api_name            = azurerm_api_management_api.user_service.name
  product_id          = azurerm_api_management_product.main.product_id
  api_management_name = azurerm_api_management.main.name
  resource_group_name = var.resource_group_name
}

# Associate Data Service API with Product
resource "azurerm_api_management_product_api" "data_service" {
  api_name            = azurerm_api_management_api.data_service.name
  product_id          = azurerm_api_management_product.main.product_id
  api_management_name = azurerm_api_management.main.name
  resource_group_name = var.resource_group_name
}

# Policy for rate limiting
resource "azurerm_api_management_product_policy" "main" {
  product_id          = azurerm_api_management_product.main.product_id
  api_management_name = azurerm_api_management.main.name
  resource_group_name = var.resource_group_name

  xml_content = <<XML
<policies>
  <inbound>
    <rate-limit calls="100" renewal-period="60" />
    <quota calls="1000" renewal-period="86400" />
    <base />
  </inbound>
  <backend>
    <base />
  </backend>
  <outbound>
    <base />
  </outbound>
  <on-error>
    <base />
  </on-error>
</policies>
XML
}

# Named value for Application Insights
resource "azurerm_api_management_named_value" "app_insights_key" {
  name                = "app-insights-key"
  resource_group_name = var.resource_group_name
  api_management_name = azurerm_api_management.main.name
  display_name        = "Application_Insights_Instrumentation_Key"
  value               = var.application_insights_id
  secret              = true
}