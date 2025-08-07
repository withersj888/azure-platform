# Variables for Azure Platform Terraform Configuration

variable "project_name" {
  description = "Name of the project used in resource naming"
  type        = string
  default     = "azplatform"

  validation {
    condition     = can(regex("^[a-z0-9]{2,12}$", var.project_name))
    error_message = "Project name must be 2-12 characters long and contain only lowercase letters and numbers."
  }
}

variable "environment" {
  description = "Environment name (dev, pre, prd)"
  type        = string

  validation {
    condition     = contains(["dev", "pre", "prd"], var.environment)
    error_message = "Environment must be one of: dev, pre, prd."
  }
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "West Europe"
}

variable "common_tags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
  default = {
    Owner      = "Platform Team"
    CostCenter = "Engineering"
  }
}

# API Management specific variables
variable "api_management_sku" {
  description = "SKU for API Management"
  type        = string
  default     = "Developer"

  validation {
    condition     = contains(["Developer", "Standard", "Premium", "Basic", "Consumption"], var.api_management_sku)
    error_message = "API Management SKU must be one of: Developer, Standard, Premium, Basic, Consumption."
  }
}

variable "api_management_capacity" {
  description = "Capacity for API Management"
  type        = number
  default     = 1
}

# Cosmos DB specific variables
variable "cosmos_db_offer_type" {
  description = "Offer type for Cosmos DB"
  type        = string
  default     = "Standard"
}

variable "cosmos_db_consistency_level" {
  description = "Consistency level for Cosmos DB"
  type        = string
  default     = "Session"

  validation {
    condition     = contains(["Eventual", "Session", "Strong", "ConsistentPrefix", "BoundedStaleness"], var.cosmos_db_consistency_level)
    error_message = "Cosmos DB consistency level must be one of: Eventual, Session, Strong, ConsistentPrefix, BoundedStaleness."
  }
}

# Function App specific variables
variable "function_app_service_plan_sku" {
  description = "SKU for Function App service plan"
  type        = string
  default     = "Y1"
}

# Key Vault specific variables
variable "key_vault_sku_name" {
  description = "SKU name for Key Vault"
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["standard", "premium"], var.key_vault_sku_name)
    error_message = "Key Vault SKU must be either 'standard' or 'premium'."
  }
}

# Monitoring specific variables
variable "application_insights_type" {
  description = "Type of Application Insights"
  type        = string
  default     = "web"
}

variable "log_analytics_sku" {
  description = "SKU for Log Analytics workspace"
  type        = string
  default     = "PerGB2018"
}

variable "log_analytics_retention_days" {
  description = "Retention period for Log Analytics in days"
  type        = number
  default     = 30
}