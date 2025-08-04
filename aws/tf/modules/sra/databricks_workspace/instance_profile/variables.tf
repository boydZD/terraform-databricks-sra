variable "crossaccount_role_name" {
  type        = string
}

variable "external_id" {
  type = string
  default = ""
  description = "External ID (E2 account ID or Storage Credential specific)"
}

variable "resource_prefix" {
  type = string
}