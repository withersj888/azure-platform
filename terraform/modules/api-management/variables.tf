# API Management Module - Variables

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "suffix" {
  description = "Random suffix for unique naming"
  type        = string
}

variable "application_insights_id" {
  description = "ID of the Application Insights instance"
  type        = string
}

variable "function_app_urls" {
  description = "URLs of the Function Apps"
  type = object({
    user_service = string
    data_service = string
  })
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}