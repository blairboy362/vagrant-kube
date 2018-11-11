variable "apiserver_address" {
  type = "string"
}

variable "cluster_domain_suffix" {
  type = "string"
}

variable "service_cidr" {
  type = "string"
}

variable "etcd_servers" {
  type = "list"
}

variable "pod_cidr" {
  type = "string"
}

variable "k8s_tag" {
  type = "string"
}

variable "assets_dir" {
  type    = "string"
  default = "/opt/bootkube/assets"
}

variable "etcd_port" {
  type    = "string"
  default = "2379"
}
