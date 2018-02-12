module "common" {
  source           = "../common"
  kubelet_token    = "${var.kubelet_token}"
  kube_proxy_token = "${var.kube_proxy_token}"
  master_ip        = "${var.master_ip}"
  cluster_dns_ip   = "${var.cluster_dns_ip}"
  cluster_cidr     = "${var.cluster_cidr}"
  pod_cidr         = "${var.pod_cidr}"
  cluster_domain = "${var.cluster_domain}"
}

data "ignition_config" "worker" {
  files   = ["${module.common.ignition_file_ids}"]
  systemd = ["${module.common.ignition_systemd_unit_ids}"]
}

output "ignition_config" {
  value = "${data.ignition_config.worker.rendered}"
}
