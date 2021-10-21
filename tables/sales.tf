# sales.tf
# Owner: Saurav Mitra
# Description: This terraform config will create the Snowflake Sales Table

# Create Sales Table
resource "snowflake_table" "sales_table" {
  database        = var.database
  schema          = var.schema
  name            = "SALES"
  comment         = "Sales Table"
  change_tracking = false

  column {
    name     = "ID"
    type     = "NUMBER(38,0)"
    nullable = false
  }

  column {
    name     = "ORDER_NUMBER"
    type     = "VARCHAR(50)"
    nullable = false
  }

  column {
    name     = "CUSTOMER_ID"
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
    name     = "DISCOUNT"
    type     = "NUMBER(38,0)"
    nullable = true
  }

  column {
    name     = "AMOUNT"
    type     = "NUMBER(38,0)"
    nullable = true
  }

  column {
    name     = "DELIVERED"
    type     = "VARCHAR(50)"
    nullable = true
  }

  column {
    name     = "CARD_TYPE"
    type     = "VARCHAR(50)"
    nullable = false
  }

  column {
    name     = "CARD_NUMBER"
    type     = "VARCHAR(50)"
    nullable = false
  }

  column {
    name     = "TXN_DATE"
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
}


# Load Data Into Sales Table
resource "snowflake_task" "sales_load_task" {
  database      = var.database
  schema        = var.schema
  warehouse     = var.warehouse
  name          = "SALES_LOAD_TASK"
  comment       = "Load Data Into Sales Table"
  enabled       = true
  sql_statement = "COPY INTO ${var.schema}.${snowflake_table.sales_table.name} FROM @${var.stage}/sales/ file_format = (type = csv field_delimiter = '|' skip_header = 1)"
  after         = snowflake_task.dates_load_task.name

  session_parameters = {
    "ODBC_QUERY_RESULT_FORMAT" : "ARROW",
  }

  depends_on = [
    snowflake_task.dates_load_task
  ]
}


# Update Sales Amount In Sales Table
resource "snowflake_task" "sales_amt_update_task" {
  database      = var.database
  schema        = var.schema
  warehouse     = var.warehouse
  name          = "SALES_AMT_UPD_TASK"
  comment       = "Update Sales Amount In Sales Table"
  enabled       = true
  sql_statement = "UPDATE ${var.schema}.SALES SALES SET AMOUNT = SALES.QUANTITY * PRODUCT.PRICE FROM ${var.schema}.PRODUCT PRODUCT WHERE sales.PRODUCT_ID = PRODUCT.ID"
  after         = snowflake_task.sales_load_task.name

  session_parameters = {
    "ODBC_QUERY_RESULT_FORMAT" : "ARROW",
  }

  depends_on = [
    snowflake_task.product_load_task,
    snowflake_task.sales_load_task
  ]
}
