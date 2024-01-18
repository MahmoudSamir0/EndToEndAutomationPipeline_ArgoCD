### AKS output
output "resource_group_location" {
  value = module.infrastructure.resource_group_location
}

output "resource_group_id" {
  value = module.infrastructure.resource_group_id
}

output "k8s_fqdn" {
  value = module.infrastructure.k8s_fqdn
}

output "client_key" {
  value = module.infrastructure.client_key
  sensitive = true
}

output "client_certificate" {
  value = module.infrastructure.client_certificate
  sensitive = true
}

output "cluster_ca_certificate" {
  value = module.infrastructure.cluster_ca_certificate
  sensitive = true
}

output "cluster_username" {
  value = module.infrastructure.cluster_username
  sensitive = true
}

output "cluster_password" {
  value = module.infrastructure.cluster_password
  sensitive = true
}

output "kube_config" {
  value = module.infrastructure.kube_config
  sensitive = true
}

output "host" {
  value = module.infrastructure.host
  sensitive = true
}



