variable "resource_group_name" {
  type        = string
  description = "Azure resource group name"
}

variable "location" {
  type        = string
  description = "Azure region"
  default     = "eastus"
}

variable "apim_name" {
  type        = string
  description = "Name for the APIM instance"
}

variable "publisher_name" {
  type        = string
  description = "Publisher name for APIM"
}

variable "publisher_email" {
  type        = string
  description = "Publisher email for APIM"
}

variable "tenant_id" {
  type        = string
  description = "Azure AD Tenant ID"
}

variable "api_audience" {
  type        = string
  description = "Expected audience claim in JWT"
}
