# variables.tf
# Owner: Saurav Mitra
# Description: Variables used by terraform config to create the Snowflake Tables
# https://www.terraform.io/docs/configuration/variables.html

variable "database" {
  description = "The snowflake database resource name."
}

variable "schema" {
  description = "The snowflake schema resource name."
}

variable "stage" {
  description = "The snowflake stage resource name."
}

variable "warehouse" {
  description = "The snowflake warehouse resource name."
}
