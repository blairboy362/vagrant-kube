variable "kubelet_token" {
  type    = "string"
  default = "8CUBtOiyuGoEB6ZosdoqZPX9VbQIRXgA"
}

variable "kube_proxy_token" {
  type    = "string"
  default = "FOmB10wdEBdJvLtL8C72P8UKVEGuTsat"
}

variable "admin_token" {
  type    = "string"
  default = "hKug05I6TteN16XIAwzcXSk5d1HZeNoJ"
}

variable "master_ip" {
  type    = "string"
  default = "10.100.100.100"
}

variable "cluster_dns_ip" {
  type    = "string"
  default = "10.110.50.10"
}

variable "etcd_cluster_map" {
  type = "map"

  default = {
    etcd-node-1 = "10.100.50.100"
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

variable "cluster_cidr" {
  type    = "string"
  default = "10.100.0.0/16"
}

variable "cluster_domain" {
  type = "string"
  default = "k8s.local"
}
