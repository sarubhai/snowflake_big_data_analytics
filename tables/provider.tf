# Name: provider.tf
# Owner: Saurav Mitra
# Description: This terraform config will Configure Terraform Provider
# https://www.terraform.io/docs/language/providers/requirements.html

terraform {
  required_providers {
    snowflake = {
      source  = "chanzuckerberg/snowflake"
      version = "0.25.22"
    }
  }
}
