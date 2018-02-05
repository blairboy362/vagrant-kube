variable "kubelet_token" {
  type = "string"
}

variable "kube_proxy_token" {
  type = "string"
}

variable "master_ip" {
  type = "string"
}

variable "cluster_dns_ip" {
  type = "string"
}

variable "node_name" {
  type = "string"
}

variable "node_ip" {
  type = "string"
}

variable "cluster_cidr" {
  type = "string"
}

variable "cluster_map" {
  type = "map"
}

variable "pod_cidr" {
  type = "string"
}
