### AKS output
output "resource_group_location" {
  value = azurerm_resource_group.group.location
}

output "resource_group_id" {
  value = azurerm_resource_group.group.id
}

output "k8s_fqdn" {
  value = module.aks.fqdn
}

output "client_key" {
  value = module.aks.client_key
}

output "client_certificate" {
  value = module.aks.client_certificate
}

output "cluster_ca_certificate" {
  value = module.aks.cluster_ca_certificate
}

output "cluster_username" {
  value = module.aks.cluster_username
}

output "cluster_password" {
  value = module.aks.cluster_password
}

output "kube_config" {
  value = module.aks.kube_config
}

output "host" {
  value = module.aks.host
}

