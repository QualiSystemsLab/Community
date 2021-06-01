resource "azurerm_managed_disk" "vm_disk" {
  for_each             = local.map
  name                 = "tf-disk_${index(keys(local.map), each.key)}"
  location             = data.azurerm_resource_group.sandbox_rg.location
  resource_group_name  = data.azurerm_resource_group.sandbox_rg.name
  storage_account_type = (each.value != ":SSD" ? var.type_hdd : var.type_ssd)
  create_option        = "Empty"
  disk_size_gb         = each.key

  tags = {
    description = "Created by terraform"
  }
}

resource "azurerm_virtual_machine_data_disk_attachment" "vm_disk_attach" {
  for_each           = local.map
  managed_disk_id    = values(azurerm_managed_disk.vm_disk)[index(keys(local.map), each.key)].id
  virtual_machine_id = data.azurerm_virtual_machine.main.id
  lun                = index(keys(local.map), each.key)
  caching            = var.caching
}



