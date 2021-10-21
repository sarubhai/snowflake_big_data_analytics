# dates.tf
# Owner: Saurav Mitra
# Description: This terraform config will create the Snowflake Dates Table

# Create Dates Table
resource "snowflake_table" "dates_table" {
  database        = var.database
  schema          = var.schema
  name            = "DATES"
  comment         = "Dates Table"
  change_tracking = false

  column {
    name     = "YEAR_NUMBER"
    type     = "NUMBER(38,0)"
    nullable = false
  }

  column {
    name     = "MONTH_NUMBER"
    type     = "NUMBER(38,0)"
    nullable = false
  }

  column {
    name     = "DAY_OF_YEAR_NUMBER"
    type     = "NUMBER(38,0)"
    nullable = false
  }

  column {
    name     = "DAY_OF_MONTH_NUMBER"
    type     = "NUMBER(38,0)"
    nullable = false
  }

  column {
    name     = "DAY_OF_WEEK_NUMBER"
    type     = "NUMBER(38,0)"
    nullable = false
  }

  column {
    name     = "WEEK_OF_YEAR_NUMBER"
    type     = "NUMBER(38,0)"
    nullable = false
  }

  column {
    name     = "DAY_NAME"
    type     = "VARCHAR(10)"
    nullable = false
  }

  column {
    name     = "MONTH_NAME"
    type     = "VARCHAR(10)"
    nullable = false
  }

  column {
    name     = "QUARTER_NUMBER"
    type     = "NUMBER(38,0)"
    nullable = false
  }

  column {
    name     = "QUARTER_NAME"
    type     = "VARCHAR(2)"
    nullable = false
  }

  column {
    name     = "YEAR_QUARTER_NAME"
    type     = "VARCHAR(6)"
    nullable = false
  }

  column {
    name     = "WEEKEND_IND"
    type     = "VARCHAR(1)"
    nullable = false
  }

  column {
    name     = "DAYS_IN_MONTH_QTY"
    type     = "NUMBER(38,0)"
    nullable = false
  }

  column {
    name     = "DATE_SK"
    type     = "NUMBER(38,0)"
    nullable = false
  }

  column {
    name     = "DAY_DESC"
    type     = "DATE"
    nullable = false
  }

  column {
    name     = "WEEK_SK"
    type     = "NUMBER(38,0)"
    nullable = false
  }

  column {
    name     = "DAY_DATE"
    type     = "DATE"
    nullable = false
  }

  column {
    name     = "WEEK_NAME"
    type     = "VARCHAR(7)"
    nullable = false
  }

  column {
    name     = "WEEK_OF_MONTH_NUMBER"
    type     = "NUMBER(38,0)"
    nullable = false
  }

  column {
    name     = "WEEK_OF_MONTH_NAME"
    type     = "VARCHAR(3)"
    nullable = false
  }

  column {
    name     = "MONTH_SK"
    type     = "NUMBER(38,0)"
    nullable = false
  }

  column {
    name     = "QUARTER_SK"
    type     = "NUMBER(38,0)"
    nullable = false
  }

  column {
    name     = "YEAR_SK"
    type     = "NUMBER(38,0)"
    nullable = false
  }

  column {
    name     = "YEAR_SORT_NUMBER"
    type     = "NUMBER(38,0)"
    nullable = false
  }

  column {
    name     = "DAY_OF_WEEK_SORT_NAME"
    type     = "VARCHAR(7)"
    nullable = false
  }
}


# Load Data Into Dates Table
resource "snowflake_task" "dates_load_task" {
  database      = var.database
  schema        = var.schema
  warehouse     = var.warehouse
  name          = "DATES_LOAD_TASK"
  comment       = "Load Data Into Dates Table"
  enabled       = true
  sql_statement = "COPY INTO ${var.schema}.${snowflake_table.dates_table.name} FROM @${var.stage}/dates/ file_format = (type = csv field_delimiter = '|' skip_header = 1)"
  schedule      = "2 minute"

  session_parameters = {
    "ODBC_QUERY_RESULT_FORMAT" : "ARROW",
  }
}
