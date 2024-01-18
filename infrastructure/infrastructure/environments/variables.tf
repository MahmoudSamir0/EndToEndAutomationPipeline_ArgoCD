variable "resource_group_name" {
  type    = string
  default = "dev"
}

variable "location" {
  type    = string
  default = "Central US"
}


variable "environment_tag" {
  type    = string
  default = "dev"
}



variable "aks_subnet_address_space" {
  type    = string
  default = "191.0.0.0/8"
}




variable "cluster_name" {
  type    = string
  default = "k8s-cluster"
}

variable "vm_size" {
  type    = string
  default = "Standard_D2_v3"
}

variable "node_pool_name" {
  type    = string
  default = "pool_1"
}

variable "aks_dns_service_ip" {
  type    = string
  default = "10.0.0.10"
}



variable "aks_pod_cidr" {
  type    = string
  default = null
}

variable "aks_service_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
