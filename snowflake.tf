# main.tf
# Owner: Saurav Mitra
# Description: This terraform config will create the infrastructure resources for Snowflake Big Data Analytics

# Snowflake Database
resource "snowflake_database" "sf_db" {
  name    = "BDA_DB"
  comment = "Snowflake Big Data Analytics Database"
}

# Snowflake Schema
resource "snowflake_schema" "sf_schema" {
  database   = snowflake_database.sf_db.name
  name       = "CAR"
  comment    = "Car Sales Schema"
  is_managed = false
}

# Snowflake Warehouse
resource "snowflake_warehouse" "sf_warehouse" {
  name           = "BDA_WH"
  comment        = "Snowflake Big Data Analytics Warehouse"
  warehouse_size = var.snowflake_wh_size
  auto_suspend   = 300
  auto_resume    = true
}

# Snowflake Stage
resource "snowflake_stage" "sf_azure_stage" {
  name        = "AZ_BDA_EXT_STAGE"
  comment     = "Azure Storage External Stage"
  database    = snowflake_database.sf_db.name
  schema      = snowflake_schema.sf_schema.name
  url         = "azure://${azurerm_storage_account.bda_storage_acc.name}.blob.core.windows.net/${azurerm_storage_container.dataset_container.name}/datasets"
  credentials = "azure_sas_token='${data.azurerm_storage_account_sas.bda_storage_acc_sas.sas}'"
}


# Snowflake Tables
module "tables" {
  source    = "./tables"
  database  = snowflake_database.sf_db.name
  schema    = snowflake_schema.sf_schema.name
  stage     = snowflake_stage.sf_azure_stage.name
  warehouse = snowflake_warehouse.sf_warehouse.name

  depends_on = [
    azurerm_storage_blob.dataset_files
  ]
}
