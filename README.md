# Snowflake Resources deployment to explore Big Data Analytics

Deploys various Snowflake resources using Terraform to get started with Big Data Analytics.

Refer to DWBI articles at [https://dwbi.org/pages/234/big-data-analysis-using-snowflake](https://dwbi.org/pages/234/big-data-analysis-using-snowflake)

## Resources

The following Azure resources will be deployed by Terraform:

- 1 Resource Group
- 1 Storage Account
- 1 Storage Container
- 6 Storage Blob file uploads

The following Snowflake resources will be deployed by Terraform:

- 1 Database
- 1 Schema
- 1 Warehouse
- 1 Azure external Stage
- 6 Tables (DDL & COPY data from Azure Blob Storage)

### Prerequisite

Terraform is already installed in local machine.

## Usage

- Clone this repository
- Generate & setup GCP & Snowflake Access Credentials
- Add the below Terraform variable values

### terraform.tfvars

- Add the below variable values as Environment Variables

```
export ARM_SUBSCRIPTION_ID='SubscriptionId'

export ARM_TENANT_ID='TenantId'

export ARM_CLIENT_ID='ClientId'

export ARM_CLIENT_SECRET='ClientSecret'


export SNOWFLAKE_ACCOUNT='SnowflakeAccount'

export SNOWFLAKE_USER='SnowflakeUser'

export SNOWFLAKE_PASSWORD='SnowflakePassword'

```

- Change other variables in variables.tf file if needed
- terraform init
- terraform plan
- terraform apply -auto-approve
- Finally browse the Snowflake Console and explore the other services.

### Destroy Resources

- terraform destroy -auto-approve

#### Task Exec Role

use role accountadmin;
create role task_exec;
grant execute task on account to role task_exec;
grant role task_exec to role sysadmin;
