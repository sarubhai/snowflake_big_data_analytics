# showroom.tf
# Owner: Saurav Mitra
# Description: This terraform config will create the Snowflake Showroom Table

# Create Showroom Table
resource "snowflake_table" "showroom_table" {
  database        = var.database
  schema          = var.schema
  name            = "SHOWROOM"
  comment         = "Showroom Table"
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
    name     = "NAME"
    type     = "VARCHAR(50)"
    nullable = false
  }

  column {
    name     = "OPERATION_DATE"
    type     = "DATE"
    nullable = true
  }

  column {
    name     = "STAFF_COUNT"
    type     = "NUMBER(38,0)"
    nullable = true
  }

  column {
    name     = "COUNTRY"
    type     = "VARCHAR(50)"
    nullable = true
  }

  column {
    name     = "STATE"
    type     = "VARCHAR(50)"
    nullable = true
  }

  column {
    name     = "ADDRESS"
    type     = "VARCHAR(50)"
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


# Load Data Into Showroom Table
resource "snowflake_task" "showroom_load_task" {
  database      = var.database
  schema        = var.schema
  warehouse     = var.warehouse
  name          = "SHOWROOM_LOAD_TASK"
  comment       = "Load Data Into Showroom Table"
  enabled       = true
  sql_statement = "COPY INTO ${var.schema}.${snowflake_table.showroom_table.name} FROM @${var.stage}/showroom/ file_format = (type = csv field_delimiter = '|' skip_header = 1)"
  after         = snowflake_task.dates_load_task.name

  session_parameters = {
    "ODBC_QUERY_RESULT_FORMAT" : "ARROW",
  }

  depends_on = [
    snowflake_task.dates_load_task
  ]
}
