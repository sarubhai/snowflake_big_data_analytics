# customer.tf
# Owner: Saurav Mitra
# Description: This terraform config will create the Snowflake Customer Table

# Create Customer Table
resource "snowflake_table" "customer_table" {
  database        = var.database
  schema          = var.schema
  name            = "CUSTOMER"
  comment         = "Customer Table"
  change_tracking = false

  column {
    name     = "ID"
    type     = "NUMBER(38,0)"
    nullable = false
  }

  column {
    name     = "FIRST_NAME"
    type     = "VARCHAR(50)"
    nullable = false
  }

  column {
    name     = "LAST_NAME"
    type     = "VARCHAR(50)"
    nullable = true
  }

  column {
    name     = "GENDER"
    type     = "VARCHAR(50)"
    nullable = true
  }

  column {
    name     = "DOB"
    type     = "DATE"
    nullable = true
  }

  column {
    name     = "COMPANY"
    type     = "VARCHAR(50)"
    nullable = true
  }

  column {
    name     = "JOB"
    type     = "VARCHAR(50)"
    nullable = true
  }

  column {
    name     = "EMAIL"
    type     = "VARCHAR(50)"
    nullable = false
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
}


# Load Data Into Customer Table
resource "snowflake_task" "customer_load_task" {
  database      = var.database
  schema        = var.schema
  warehouse     = var.warehouse
  name          = "CUSTOMER_LOAD_TASK"
  comment       = "Load Data Into Customer Table"
  enabled       = true
  sql_statement = "COPY INTO ${var.schema}.${snowflake_table.customer_table.name} FROM @${var.stage}/customer/ file_format = (type = csv field_delimiter = '|' skip_header = 1)"
  after         = snowflake_task.dates_load_task.name

  session_parameters = {
    "ODBC_QUERY_RESULT_FORMAT" : "ARROW",
  }

  depends_on = [
    snowflake_task.dates_load_task
  ]
}
