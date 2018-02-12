variable "kubelet_token" {
  type = "string"
}

variable "kube_proxy_token" {
  type = "string"
}

variable "admin_token" {
  type = "string"
}

variable "master_ip" {
  type = "string"
}

variable "cluster_dns_ip" {
  type = "string"
}

variable "etcd_servers" {
  type = "list"
}

variable "service_cluster_ip_range" {
  type = "string"
}

variable "pod_cidr" {
  type = "string"
}

variable "cluster_cidr" {
  type = "string"
}

variable "cluster_domain" {
  type = "string"
}
