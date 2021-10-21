# stocks.tf
# Owner: Saurav Mitra
# Description: This terraform config will create the Snowflake Stocks Table

# Create Stocks Table
resource "snowflake_table" "stocks_table" {
  database        = var.database
  schema          = var.schema
  name            = "STOCKS"
  comment         = "Stocks Table"
  change_tracking = false

  column {
    name     = "ID"
    type     = "NUMBER(38,0)"
    nullable = false
  }

  column {
    name     = "SHOWROOM_ID"
    type     = "NUMBER(38,0)"
    nullable = false
  }

  column {
    name     = "PRODUCT_ID"
    type     = "NUMBER(38,0)"
    nullable = false
  }

  column {
    name     = "QUANTITY"
    type     = "NUMBER(38,0)"
    nullable = false
  }

  column {
    name     = "STOCK_DATE"
    type     = "DATE"
    nullable = true
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

  depends_on = [
    snowflake_table.customer_table
  ]
}


# Load Data Into Stocks Table
resource "snowflake_task" "stocks_load_task" {
  database      = var.database
  schema        = var.schema
  warehouse     = var.warehouse
  name          = "STOCKS_LOAD_TASK"
  comment       = "Load Data Into Stocks Table"
  enabled       = true
  sql_statement = "COPY INTO ${var.schema}.${snowflake_table.stocks_table.name} FROM @${var.stage}/stocks/ file_format = (type = csv field_delimiter = '|' skip_header = 1)"
  after         = snowflake_task.dates_load_task.name

  session_parameters = {
    "ODBC_QUERY_RESULT_FORMAT" : "ARROW",
  }

  depends_on = [
    snowflake_task.dates_load_task
  ]
}
