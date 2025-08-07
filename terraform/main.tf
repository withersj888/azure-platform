# Azure Platform - Main Terraform Configuration
terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

# Random suffix for unique resource names
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# Data sources for current context
data "azurerm_client_config" "current" {}

# Local variables for naming and tagging
locals {
  # Naming convention variables
  project_name = var.project_name
  environment  = var.environment
  location     = var.location

  # Generate consistent resource names
  resource_group_name = "${local.project_name}-${local.environment}-rg"

  # Common tags applied to all resources
  common_tags = merge(var.common_tags, {
    Environment = local.environment
    Project     = local.project_name
    ManagedBy   = "Terraform"
    DeployedBy  = "Azure-DevOps"
    CreatedDate = formatdate("YYYY-MM-DD", timestamp())
  })
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = local.resource_group_name
  location = local.location
  tags     = local.common_tags
}

# Key Vault for secrets and connection strings
module "key_vault" {
  source = "./modules/key-vault"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  environment         = local.environment
  project_name        = local.project_name
  suffix              = random_string.suffix.result
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = data.azurerm_client_config.current.object_id
  tags                = local.common_tags
}

# Application Insights for monitoring
module "application_insights" {
  source = "./modules/application-insights"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  environment         = local.environment
  project_name        = local.project_name
  suffix              = random_string.suffix.result
  tags                = local.common_tags
}

# Cosmos DB for NoSQL database
module "cosmos_db" {
  source = "./modules/cosmos-db"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  environment         = local.environment
  project_name        = local.project_name
  suffix              = random_string.suffix.result
  tags                = local.common_tags

  key_vault_id = module.key_vault.key_vault_id
}

# Azure Functions
module "azure_functions" {
  source = "./modules/azure-functions"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  environment         = local.environment
  project_name        = local.project_name
  suffix              = random_string.suffix.result
  tags                = local.common_tags

  application_insights_key               = module.application_insights.instrumentation_key
  application_insights_connection_string = module.application_insights.connection_string
  cosmos_db_connection_string            = module.cosmos_db.connection_string
  key_vault_id                           = module.key_vault.key_vault_id
}

# API Management
module "api_management" {
  source = "./modules/api-management"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  environment         = local.environment
  project_name        = local.project_name
  suffix              = random_string.suffix.result
  tags                = local.common_tags

  application_insights_id = module.application_insights.id
  function_app_urls       = module.azure_functions.function_app_urls
}