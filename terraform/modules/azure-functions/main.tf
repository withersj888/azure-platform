# Azure Functions Module - Main Configuration

# Storage Account for Function Apps
resource "azurerm_storage_account" "functions" {
  name                     = "${replace(var.project_name, "-", "")}${var.environment}st${var.suffix}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  tags = var.tags
}

# App Service Plan for Function Apps
resource "azurerm_service_plan" "functions" {
  name                = "${var.project_name}-${var.environment}-asp-${var.suffix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "Y1"

  tags = var.tags
}

# Function App 1 - User Management Service
resource "azurerm_linux_function_app" "user_service" {
  name                       = "${var.project_name}-${var.environment}-func-user-${var.suffix}"
  resource_group_name        = var.resource_group_name
  location                   = var.location
  service_plan_id            = azurerm_service_plan.functions.id
  storage_account_name       = azurerm_storage_account.functions.name
  storage_account_access_key = azurerm_storage_account.functions.primary_access_key

  site_config {
    application_stack {
      node_version = "18"
    }
  }

  app_settings = {
    "FUNCTIONS_EXTENSION_VERSION"           = "~4"
    "WEBSITE_NODE_DEFAULT_VERSION"          = "~18"
    "APPINSIGHTS_INSTRUMENTATIONKEY"        = var.application_insights_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = var.application_insights_connection_string
    "COSMOS_DB_CONNECTION_STRING"           = var.cosmos_db_connection_string
    "AzureWebJobsDisableHomepage"           = "true"
  }

  # Identity for Key Vault access
  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# Function App 2 - Data Processing Service
resource "azurerm_linux_function_app" "data_service" {
  name                       = "${var.project_name}-${var.environment}-func-data-${var.suffix}"
  resource_group_name        = var.resource_group_name
  location                   = var.location
  service_plan_id            = azurerm_service_plan.functions.id
  storage_account_name       = azurerm_storage_account.functions.name
  storage_account_access_key = azurerm_storage_account.functions.primary_access_key

  site_config {
    application_stack {
      node_version = "18"
    }
  }

  app_settings = {
    "FUNCTIONS_EXTENSION_VERSION"           = "~4"
    "WEBSITE_NODE_DEFAULT_VERSION"          = "~18"
    "APPINSIGHTS_INSTRUMENTATIONKEY"        = var.application_insights_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = var.application_insights_connection_string
    "COSMOS_DB_CONNECTION_STRING"           = var.cosmos_db_connection_string
    "AzureWebJobsDisableHomepage"           = "true"
  }

  # Identity for Key Vault access
  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# Key Vault access policy for User Service Function App
resource "azurerm_key_vault_access_policy" "user_service" {
  key_vault_id = var.key_vault_id
  tenant_id    = azurerm_linux_function_app.user_service.identity[0].tenant_id
  object_id    = azurerm_linux_function_app.user_service.identity[0].principal_id

  secret_permissions = [
    "Get",
    "List"
  ]
}

# Key Vault access policy for Data Service Function App
resource "azurerm_key_vault_access_policy" "data_service" {
  key_vault_id = var.key_vault_id
  tenant_id    = azurerm_linux_function_app.data_service.identity[0].tenant_id
  object_id    = azurerm_linux_function_app.data_service.identity[0].principal_id

  secret_permissions = [
    "Get",
    "List"
  ]
}