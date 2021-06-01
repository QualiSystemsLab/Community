terraform {
  required_providers {
    azurerm = {
      version = "2.58"
    }
  }
}

provider azurerm {
  features {}
}

resource "azurerm_managed_disk" "vm_disk_J" {
  name                 = "${var.VM_NAME}-J-Disk-${var.SANDBOX_ID}"
  location             = data.azurerm_resource_group.sandbox_rg.location
  resource_group_name  = data.azurerm_resource_group.sandbox_rg.name
  storage_account_type = "StandardSSD_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.SYSTEM_STORAGE
}

resource "azurerm_managed_disk" "vm_disk_L" {
  name                 = "${var.VM_NAME}-L-Disk-${var.SANDBOX_ID}"
  location             = data.azurerm_resource_group.sandbox_rg.location
  resource_group_name  = data.azurerm_resource_group.sandbox_rg.name
  storage_account_type = "StandardSSD_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.LOG_STORAGE
}

resource "azurerm_managed_disk" "vm_disk_M" {
  name                 = "${var.VM_NAME}-M-Disk-${var.SANDBOX_ID}"
  location             = data.azurerm_resource_group.sandbox_rg.location
  resource_group_name  = data.azurerm_resource_group.sandbox_rg.name
  storage_account_type = "StandardSSD_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.DATA_STORAGE
}

resource "azurerm_managed_disk" "vm_disk_T" {
  name                 = "${var.VM_NAME}-T-Disk-${var.SANDBOX_ID}"
  location             = data.azurerm_resource_group.sandbox_rg.location
  resource_group_name  = data.azurerm_resource_group.sandbox_rg.name
  storage_account_type = "StandardSSD_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.TEMP_STORAGE
}




resource "azurerm_virtual_machine_data_disk_attachment" "vm_disk_attach_L" {
  managed_disk_id    = azurerm_managed_disk.vm_disk_L.id
  virtual_machine_id = data.azurerm_virtual_machine.main.id
  lun                = 2
  caching            = var.caching
}

resource "azurerm_virtual_machine_data_disk_attachment" "vm_disk_attach_M" {
  managed_disk_id    = azurerm_managed_disk.vm_disk_M.id
  virtual_machine_id = data.azurerm_virtual_machine.main.id
  lun                = 3
  caching            = var.caching
}

resource "azurerm_virtual_machine_data_disk_attachment" "vm_disk_attach_J" {
  managed_disk_id    = azurerm_managed_disk.vm_disk_J.id
  virtual_machine_id = data.azurerm_virtual_machine.main.id
  lun                = 4
  caching            = var.caching
}

resource "azurerm_virtual_machine_data_disk_attachment" "vm_disk_attach_T" {
  managed_disk_id    = azurerm_managed_disk.vm_disk_T.id
  virtual_machine_id = data.azurerm_virtual_machine.main.id
  lun                = 5
  caching            = var.caching
}