# Name: provider.tf
# Owner: Saurav Mitra
# Description: This terraform config will Configure Terraform Providers
# https://www.terraform.io/docs/language/providers/requirements.html

terraform {
  required_providers {
    snowflake = {
      source  = "chanzuckerberg/snowflake"
      version = "0.25.22"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.0"
    }
  }
}

# Configure Terraform Snowflake Provider
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs

# $ export SNOWFLAKE_ACCOUNT='SnowflakeAccount'
# $ export SNOWFLAKE_USER='SnowflakeUser'
# $ export SNOWFLAKE_PASSWORD='SnowflakePassword'

provider "snowflake" {
  # Configuration options
  role = var.snowflake_role
}


# Configure Terraform Azure Provider
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs

# $ export ARM_SUBSCRIPTION_ID='SubscriptionId'
# $ export ARM_TENANT_ID='TenantId'
# $ export ARM_CLIENT_ID='ClientId'
# $ export ARM_CLIENT_SECRET='ClientSecret'

provider "azurerm" {
  # Configuration options
  features {}
}
