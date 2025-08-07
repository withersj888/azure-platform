# Key Vault Module - Variables

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

variable "tenant_id" {
  description = "Azure tenant ID"
  type        = string
}

variable "object_id" {
  description = "Object ID of the current user/service principal"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}