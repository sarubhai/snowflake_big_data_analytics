# azure_storage.tf
# Owner: Saurav Mitra
# Description: This terraform config will create the Blob Storage Container

# Azure Resource Group
resource "azurerm_resource_group" "azure_rg" {
  name     = "${var.prefix}-rg"
  location = var.rg_location

  tags = {
    Name    = "${var.prefix}-rg"
    Owner   = var.owner
    Project = var.prefix
  }
}

resource "random_integer" "rid" {
  min = 100
  max = 900
}

locals {
  suffix                 = random_integer.rid.result
  storage_account_name   = "bdastorageacc${local.suffix}"
  dataset_container_name = "bdadataset${local.suffix}"
}

# Azure Storage Account
resource "azurerm_storage_account" "bda_storage_acc" {
  name                     = local.storage_account_name
  location                 = azurerm_resource_group.azure_rg.location
  resource_group_name      = azurerm_resource_group.azure_rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    Name    = local.storage_account_name
    Owner   = var.owner
    Project = var.prefix
  }
}

# Azure Container
resource "azurerm_storage_container" "dataset_container" {
  name                  = local.dataset_container_name
  storage_account_name  = azurerm_storage_account.bda_storage_acc.name
  container_access_type = "private"
}

# Upload Sample Dataset Files to Container
resource "azurerm_storage_blob" "dataset_files" {
  for_each               = fileset(path.module, "**/*.psv")
  name                   = each.value
  storage_account_name   = azurerm_storage_account.bda_storage_acc.name
  storage_container_name = azurerm_storage_container.dataset_container.name
  type                   = "Block"
  source                 = "${path.module}/${each.value}"
}

# Shared Access Signature Token for the Storage Account
data "azurerm_storage_account_sas" "bda_storage_acc_sas" {
  connection_string = azurerm_storage_account.bda_storage_acc.primary_connection_string
  signed_version    = "2017-07-29"

  services {
    blob  = true
    file  = true
    queue = true
    table = true
  }

  resource_types {
    service   = true
    container = true
    object    = true
  }

  permissions {
    read    = true
    write   = false
    delete  = false
    list    = true
    add     = false
    create  = false
    update  = false
    process = false
  }

  start      = var.sas_start
  expiry     = var.sas_expiry
  https_only = true
}
