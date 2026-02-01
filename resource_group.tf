resource "azurerm_resource_group" "rg" {
  name     = "terraform-rg"
  location = "Switzerland North"

  tags = { environment = "dev" }
}