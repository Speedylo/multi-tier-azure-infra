resource "azurerm_public_ip" "web-vm-public_ip" {
  name                = "web-vm-public_ip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"

  tags = { environment = "dev" }
}

resource "azurerm_network_interface" "web-vm-nic" {
  name                = "web-vm-nic"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.public-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web-vm-public_ip.id
  }

  tags = { environment = "dev" }
}

resource "azurerm_linux_virtual_machine" "web-vm" {
  name                  = "web-vm"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = "Standard_B2ats_v2"
  admin_username        = "younes"
  network_interface_ids = [azurerm_network_interface.web-vm-nic.id]

  admin_ssh_key {
    username   = "younes"
    public_key = file("~/.ssh/ansible.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}

resource "azurerm_network_interface" "db-vm-nic" {
  name                = "db-vm-nic"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.private-subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = { environment = "dev" }
}

resource "azurerm_linux_virtual_machine" "db-vm" {
  name                  = "db-vm"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = "Standard_B2ats_v2"
  admin_username        = "younes"
  network_interface_ids = [azurerm_network_interface.db-vm-nic.id]

  admin_ssh_key {
    username   = "younes"
    public_key = file("~/.ssh/ansible.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}

resource "azurerm_network_interface" "monitoring-vm-nic" {
  name                = "monitoring-vm-nic"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.private-subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = { environment = "dev" }
}

resource "azurerm_linux_virtual_machine" "monitoring-vm" {
  name                  = "monitoring-vm"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = "Standard_B2ats_v2"
  admin_username        = "younes"
  network_interface_ids = [azurerm_network_interface.monitoring-vm-nic.id]

  admin_ssh_key {
    username   = "younes"
    public_key = file("~/.ssh/ansible.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}