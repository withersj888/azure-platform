# Cosmos DB Module - Main Configuration

# Cosmos DB Account
resource "azurerm_cosmosdb_account" "main" {
  name                = "${var.project_name}-${var.environment}-cosmos-${var.suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  # Enable automatic failover
  automatic_failover_enabled       = true
  multiple_write_locations_enabled = false

  # Consistency policy
  consistency_policy {
    consistency_level       = "Session"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }

  # Geographic locations
  geo_location {
    location          = var.location
    failover_priority = 0
  }

  # Backup policy
  backup {
    type                = "Periodic"
    interval_in_minutes = 240
    retention_in_hours  = 8
    storage_redundancy  = "Geo"
  }

  tags = var.tags
}

# Cosmos DB SQL Database
resource "azurerm_cosmosdb_sql_database" "main" {
  name                = "${var.project_name}-${var.environment}-db"
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.main.name

  # Shared throughput at database level
  throughput = 400
}

# Container for microservices data
resource "azurerm_cosmosdb_sql_container" "microservices" {
  name                  = "microservices"
  resource_group_name   = var.resource_group_name
  account_name          = azurerm_cosmosdb_account.main.name
  database_name         = azurerm_cosmosdb_sql_database.main.name
  partition_key_path    = "/id"
  partition_key_version = 1

  # Indexing policy
  indexing_policy {
    indexing_mode = "consistent"

    included_path {
      path = "/*"
    }

    excluded_path {
      path = "/\"_etag\"/?"
    }
  }

  # Unique key policy
  unique_key {
    paths = ["/definition/idlong", "/definition/idshort"]
  }
}

# Container for user data
resource "azurerm_cosmosdb_sql_container" "users" {
  name                  = "users"
  resource_group_name   = var.resource_group_name
  account_name          = azurerm_cosmosdb_account.main.name
  database_name         = azurerm_cosmosdb_sql_database.main.name
  partition_key_path    = "/userId"
  partition_key_version = 1

  # Indexing policy
  indexing_policy {
    indexing_mode = "consistent"

    included_path {
      path = "/*"
    }

    excluded_path {
      path = "/\"_etag\"/?"
    }
  }
}

# Store connection string in Key Vault
resource "azurerm_key_vault_secret" "cosmos_connection_string" {
  name         = "cosmos-db-connection-string"
  value        = azurerm_cosmosdb_account.main.primary_sql_connection_string
  key_vault_id = var.key_vault_id

  tags = var.tags
}

resource "azurerm_key_vault_secret" "cosmos_primary_key" {
  name         = "cosmos-db-primary-key"
  value        = azurerm_cosmosdb_account.main.primary_key
  key_vault_id = var.key_vault_id

  tags = var.tags
}

resource "azurerm_key_vault_secret" "cosmos_endpoint" {
  name         = "cosmos-db-endpoint"
  value        = azurerm_cosmosdb_account.main.endpoint
  key_vault_id = var.key_vault_id

  tags = var.tags
}