module "etcd1" {
  source           = "../../modules/config/etcd"
  kubelet_token    = "${var.kubelet_token}"
  kube_proxy_token = "${var.kube_proxy_token}"
  master_ip        = "${var.master_ip}"
  cluster_dns_ip   = "${var.cluster_dns_ip}"
  node_name        = "etcd-node-1"
  node_ip          = "10.100.50.100"
  cluster_map      = "${var.etcd_cluster_map}"
  cluster_cidr     = "${var.cluster_cidr}"
  pod_cidr         = "${var.pod_cidr}"
  cluster_domain = "${var.cluster_domain}"
}

output "etcd1" {
  value = "${module.etcd1.ignition_config}"
}

module "etcd2" {
  source           = "../../modules/config/etcd"
  kubelet_token    = "${var.kubelet_token}"
  kube_proxy_token = "${var.kube_proxy_token}"
  master_ip        = "${var.master_ip}"
  cluster_dns_ip   = "${var.cluster_dns_ip}"
  node_name        = "etcd-node-2"
  node_ip          = "10.100.50.101"
  cluster_map      = "${var.etcd_cluster_map}"
  cluster_cidr     = "${var.cluster_cidr}"
  pod_cidr         = "${var.pod_cidr}"
  cluster_domain = "${var.cluster_domain}"
}

output "etcd2" {
  value = "${module.etcd2.ignition_config}"
}

module "etcd3" {
  source           = "../../modules/config/etcd"
  kubelet_token    = "${var.kubelet_token}"
  kube_proxy_token = "${var.kube_proxy_token}"
  master_ip        = "${var.master_ip}"
  cluster_dns_ip   = "${var.cluster_dns_ip}"
  node_name        = "etcd-node-3"
  node_ip          = "10.100.50.102"
  cluster_map      = "${var.etcd_cluster_map}"
  cluster_cidr     = "${var.cluster_cidr}"
  pod_cidr         = "${var.pod_cidr}"
  cluster_domain = "${var.cluster_domain}"
}

output "etcd3" {
  value = "${module.etcd3.ignition_config}"
}

module "master" {
  source                   = "../../modules/config/master"
  kubelet_token            = "${var.kubelet_token}"
  kube_proxy_token         = "${var.kube_proxy_token}"
  admin_token              = "${var.admin_token}"
  master_ip                = "${var.master_ip}"
  cluster_dns_ip           = "${var.cluster_dns_ip}"
  etcd_servers             = "${values("${var.etcd_cluster_map}")}"
  service_cluster_ip_range = "${var.service_cluster_ip_range}"
  pod_cidr                 = "${var.pod_cidr}"
  cluster_cidr             = "${var.cluster_cidr}"
  cluster_domain = "${var.cluster_domain}"
}

output "master" {
  value = "${module.master.ignition_config}"
}

module "worker" {
  source           = "../../modules/config/worker"
  kubelet_token    = "${var.kubelet_token}"
  kube_proxy_token = "${var.kube_proxy_token}"
  master_ip        = "${var.master_ip}"
  cluster_dns_ip   = "${var.cluster_dns_ip}"
  cluster_cidr     = "${var.cluster_cidr}"
  pod_cidr         = "${var.pod_cidr}"
  cluster_domain = "${var.cluster_domain}"
}

output "worker" {
  value = "${module.worker.ignition_config}"
}

module "client" {
  source                   = "../../modules/config/client"
  admin_token              = "${var.admin_token}"
  master_ip                = "${var.master_ip}"
  pod_cidr                 = "${var.pod_cidr}"
  cluster_domain           = "${var.cluster_domain}"
  service_cluster_ip_range = "${var.service_cluster_ip_range}"
  cluster_dns_ip           = "${var.cluster_dns_ip}"
}

output "client_kubeconfig" {
  value = "${module.client.kubeconfig}"
}

output "canal_yaml" {
  value = "${module.client.canal_yaml}"
}

output "coredns_values_yaml" {
  value = "${module.client.coredns_values_yaml}"
}

output "kube_proxy_yaml" {
  value = "${module.client.kube_proxy_yaml}"
}
