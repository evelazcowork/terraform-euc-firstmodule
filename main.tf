resource "azurerm_resource_group" "rg_euc_sandbox" {
  name     = "rg_euc_sandbox"
  location = "East US"
}

resource "azurerm_virtual_network" "vnet_euc_sandbox" {
  name                = "vnet_euc_sandbox"
  address_space       = ["10.12.255.80/28"]
  location            = azurerm_resource_group.rg_euc_sandbox.location
  resource_group_name = azurerm_resource_group.rg_euc_sandbox.name
}

resource "azurerm_subnet" "subnet_int_euc_sandbox" {
  name                 = "subnet_int_euc_sandbox"
  resource_group_name  = azurerm_resource_group.rg_euc_sandbox.name
  virtual_network_name = azurerm_virtual_network.vnet_euc_sandbox.name
  address_prefixes     = ["10.12.255.80/29"]
}

resource "azurerm_network_interface" "nic_euc_sandbox" {
  name                = "nic-euc_sandbox"
  location            = azurerm_resource_group.rg_euc_sandbox.location
  resource_group_name = azurerm_resource_group.rg_euc_sandbox.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_int_euc_sandbox.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "windows_euc_sandbox" {
  name                = "win-ev-sandbox" # Must be 15 characters or less
  resource_group_name = azurerm_resource_group.rg_euc_sandbox.name
  location            = azurerm_resource_group.rg_euc_sandbox.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.nic_euc_sandbox.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  #Get the private IP address of the VM and write it to a file / Must be inside the VM code block
  provisioner "local-exec" {
    command = "echo ${self.private_ip_address} >> private_ip_address.txt"
  }
}

resource "azurerm_storage_account" "eucstoragesandbox" {
  name                     = "eucstoragesandbox"
  resource_group_name      = "rg_euc_sandbox"
  location                 = "East US"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
