# Development Environment Backend Configuration
# This file configures the Terraform backend for the development environment

terraform {
  backend "azurerm" {
    # These values should be set via environment variables or command line
    # resource_group_name  = "terraform-state-rg"
    # storage_account_name = "terraformstateXXXXXX"
    # container_name       = "tfstate"
    # key                  = "dev/terraform.tfstate"
  }
}