resource "azurerm_container_registry" "acr" {
  name                     = "containerRegistrymah1"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  sku                      = "Standard"
  admin_enabled            = false
}