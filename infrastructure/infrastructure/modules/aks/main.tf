
resource "azurerm_kubernetes_cluster" "k8s" {
  name                = var.cluster_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name           = var.node_pool_name
    node_count     = var.k8s_node
    vm_size        = var.vm_size
    vnet_subnet_id = var.subnet_id
    enable_auto_scaling = true
    min_count = 1
    max_count = 2
  }

  network_profile {
    network_plugin     = var.network_plugin
    network_policy     = var.network_plugin
    dns_service_ip     = var.dns_service_ip
    pod_cidr           = var.pod_cidr
    service_cidr       = var.service_cidr
  }

  identity {
    type = var.identity
  }

  tags = {
    Environment = var.environment_tag
  }
}
resource "azurerm_role_assignment" "kubweb_to_acr" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.k8s.identity[0].principal_id
  skip_service_principal_aad_check = true

}