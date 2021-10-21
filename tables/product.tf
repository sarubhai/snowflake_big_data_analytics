# product.tf
# Owner: Saurav Mitra
# Description: This terraform config will create the Snowflake Product Table

# Create Product Table
resource "snowflake_table" "product_table" {
  database        = var.database
  schema          = var.schema
  name            = "PRODUCT"
  comment         = "Product Table"
  change_tracking = false

  column {
    name     = "ID"
    type     = "NUMBER(38,0)"
    nullable = false
  }

  column {
    name     = "CODE"
    type     = "VARCHAR(50)"
    nullable = false
  }

  column {
    name     = "CATEGORY"
    type     = "VARCHAR(6)"
    nullable = false
  }

  column {
    name     = "MAKE"
    type     = "VARCHAR(50)"
    nullable = false
  }

  column {
    name     = "MODEL"
    type     = "VARCHAR(50)"
    nullable = false
  }

  column {
    name     = "YEAR"
    type     = "NUMBER(38,0)"
    nullable = false
  }

  column {
    name     = "COLOR"
    type     = "VARCHAR(50)"
    nullable = true
  }

  column {
    name     = "PRICE"
    type     = "NUMBER(38,0)"
    nullable = false
  }

  column {
    name     = "CURRENCY"
    type     = "VARCHAR(3)"
    nullable = false
  }

  column {
    name     = "UPDATE_DATE"
    type     = "TIMESTAMP_NTZ(9)"
    nullable = false
  }

  column {
    name     = "CREATE_DATE"
    type     = "TIMESTAMP_NTZ(9)"
    nullable = false
  }
}


# Load Data Into Product Table
resource "snowflake_task" "product_load_task" {
  database      = var.database
  schema        = var.schema
  warehouse     = var.warehouse
  name          = "PRODUCT_LOAD_TASK"
  comment       = "Load Data Into Product Table"
  enabled       = true
  sql_statement = "COPY INTO ${var.schema}.${snowflake_table.product_table.name} FROM @${var.stage}/product/ file_format = (type = csv field_delimiter = '|' skip_header = 1)"
  after         = snowflake_task.dates_load_task.name

  session_parameters = {
    "ODBC_QUERY_RESULT_FORMAT" : "ARROW",
  }

  depends_on = [
    snowflake_task.dates_load_task
  ]
}
