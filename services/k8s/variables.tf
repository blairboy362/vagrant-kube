variable "master_ip" {
  type    = "string"
  default = "10.100.100.100"
}

variable "etcd_cluster_map" {
  type = "map"

  default = {
    etcd1 = "10.100.50.100"
  }
}

variable "service_cluster_ip_range" {
  type    = "string"
  default = "10.110.0.0/16"
}

variable "pod_cidr" {
  type    = "string"
  default = "10.120.0.0/16"
}

variable "cluster_domain" {
  type    = "string"
  default = "cluster.local"
}

variable "k8s_tag" {
  type = "string"
  default = "v1.11.4"
}
