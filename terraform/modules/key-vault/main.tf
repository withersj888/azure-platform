# Key Vault Module - Main Configuration

resource "azurerm_key_vault" "main" {
  name                       = "${var.project_name}-${var.environment}-kv-${var.suffix}"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = var.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  # Enable access for Azure services
  enabled_for_deployment          = true
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true

  # Network access rules
  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
  }

  tags = var.tags
}

# Access policy for the current user/service principal
resource "azurerm_key_vault_access_policy" "current_user" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = var.tenant_id
  object_id    = var.object_id

  certificate_permissions = [
    "Create",
    "Delete",
    "Get",
    "List",
    "Purge",
    "Recover",
    "Update"
  ]

  key_permissions = [
    "Create",
    "Delete",
    "Get",
    "List",
    "Purge",
    "Recover",
    "Update",
    "Decrypt",
    "Encrypt",
    "Sign",
    "Verify"
  ]

  secret_permissions = [
    "Delete",
    "Get",
    "List",
    "Purge",
    "Recover",
    "Set"
  ]

  storage_permissions = [
    "Delete",
    "Get",
    "List",
    "Purge",
    "Recover",
    "Set",
    "Update"
  ]
}

# Create secrets placeholders that will be populated by other modules
resource "azurerm_key_vault_secret" "cosmos_db_connection_string" {
  name         = "cosmos-db-connection-string"
  value        = "placeholder" # This will be updated by the Cosmos DB module
  key_vault_id = azurerm_key_vault.main.id

  depends_on = [azurerm_key_vault_access_policy.current_user]

  tags = var.tags

  lifecycle {
    ignore_changes = [value]
  }
}

resource "azurerm_key_vault_secret" "application_insights_connection_string" {
  name         = "application-insights-connection-string"
  value        = "placeholder" # This will be updated by the Application Insights module
  key_vault_id = azurerm_key_vault.main.id

  depends_on = [azurerm_key_vault_access_policy.current_user]

  tags = var.tags

  lifecycle {
    ignore_changes = [value]
  }
}

resource "azurerm_key_vault_secret" "application_insights_instrumentation_key" {
  name         = "application-insights-instrumentation-key"
  value        = "placeholder" # This will be updated by the Application Insights module
  key_vault_id = azurerm_key_vault.main.id

  depends_on = [azurerm_key_vault_access_policy.current_user]

  tags = var.tags

  lifecycle {
    ignore_changes = [value]
  }
}