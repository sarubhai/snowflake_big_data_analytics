# variables.tf
# Owner: Saurav Mitra
# Description: Variables used by terraform config to create the infrastructure resources for Snowflake Big Data Analytics 
# https://www.terraform.io/docs/configuration/variables.html

# Tags
variable "prefix" {
  description = "This prefix will be included in the name of the resources."
  default     = "snowflake-big-data"
}

variable "owner" {
  description = "This owner name tag will be included in the owner of the resources."
  default     = "Saurav Mitra"
}

# Resource Group Location
variable "rg_location" {
  description = "Location of Resource Group"
  default     = "Southeast Asia"
}

# Storage Account SAS
variable "sas_start" {
  description = "SAS Start Datetime"
  default     = "2021-10-20T00:00:00Z"
}

variable "sas_expiry" {
  description = "SAS End Datetime"
  default     = "2021-12-20T00:00:00Z"
}

# Snowflake Role
variable "snowflake_role" {
  description = "Snowflake role to use for operations"
  default     = "SYSADMIN"
}

variable "snowflake_wh_size" {
  description = "Snowflake Warehouse Size"
  default     = "small"
}
