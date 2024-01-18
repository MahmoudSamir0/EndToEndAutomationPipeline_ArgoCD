resource "azurerm_resource_group" "group" {
  name     = var.resource_group_name
  location = var.location
}

module "network_aks" {
  source                  = "../modules/network"
  vnet_name = "dev-network-aks"
  resource_group_name     = var.resource_group_name
  environment_tag         = var.environment_tag
  subnet_address_space    = [var.aks_subnet_address_space]
  subnet_address_prefixes = [cidrsubnet(var.aks_subnet_address_space, 2, 0)]
  depends_on              = [azurerm_resource_group.group]
}
module "acr" {
  source = "../modules/acr"
    resource_group_name     = var.resource_group_name
    resource_group_location = var.location
}
module "aks" {
  source              = "../modules/aks"
  resource_group_name = var.resource_group_name
  environment_tag     = var.environment_tag
  cluster_name        = var.cluster_name
  vm_size             = var.vm_size
  node_pool_name      = var.node_pool_name
  subnet_id           = module.network_aks.subnet_id
  service_cidr        = var.aks_service_cidr
  dns_service_ip      = var.aks_dns_service_ip
  pod_cidr            = var.aks_pod_cidr
  depends_on          = [azurerm_resource_group.group]
  acr_id              = module.acr.acr_id
}


