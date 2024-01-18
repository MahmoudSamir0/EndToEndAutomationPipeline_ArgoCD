module "infrastructure" {
  source              = "./environments"
  resource_group_name = "terraform-env"
  location            = "Central US"
  environment_tag     = "dev"
  ############## Network configuration ###############
  ####################################################
  aks_subnet_address_space        = "191.0.0.0/8"
  ############# AKS configuration ####################
  ####################################################    
  cluster_name           = "k8s-cluster"
  vm_size                = "Standard_D2_v3"
  node_pool_name         = "devpool1"
  aks_dns_service_ip     = "10.0.0.10"
  aks_pod_cidr           = null
  aks_service_cidr       = "10.0.0.0/16"
}
