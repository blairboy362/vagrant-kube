variable "service_cidr" {
  type = "string"
}

variable "kubelet_kubeconfig" {
  type = "string"
}

variable "ignition_file_ids" {
  type = "list"
}

variable "systemd_unit_ids" {
  type = "list"
}

variable "kube_ca_crt" {
  type = "string"
}

variable "node_labels" {
  type = "string"
}

variable "node_taints" {
  type = "string"
}

variable "cluster_domain" {
  type = "string"
}

variable "k8s_tag" {
  type = "string"
}
