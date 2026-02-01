resource "azurerm_virtual_network" "VNet" {
  name                = "terraform-vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.0.0.0/16"]

  tags = { environment = "dev" }
}

resource "azurerm_subnet" "public-subnet" {
  name                 = "public-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.VNet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "private-subnet" {
  name                 = "private-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.VNet.name
  address_prefixes     = ["10.0.2.0/24"]
}

