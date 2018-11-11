module "common" {
  source = "../../modules/config/common"
}

module "bootkube" {
  source                = "../../modules/config/bootkube"
  apiserver_address     = "${var.master_ip}"
  cluster_domain_suffix = "${var.cluster_domain}"
  service_cidr          = "${var.service_cluster_ip_range}"
  etcd_servers          = "${values("${var.etcd_cluster_map}")}"
  pod_cidr              = "${var.pod_cidr}"
  k8s_tag = "${var.k8s_tag}"
}

resource "local_file" "admin-kubeconfig" {
  content  = "${module.bootkube.admin-kubeconfig}"
  filename = "client_config/kubeconfig"
}

resource "local_file" "cert-manager-secret" {
  content  = "${module.bootkube.cert-manager-secret}"
  filename = "examples/cert-manager-secret.yaml"
}

module "etcd" {
  source                 = "../../modules/config/etcd"
  cluster_map            = "${var.etcd_cluster_map}"
  etcd_ignition_file_ids = "${module.bootkube.etcd-ignition-file-ids}"
  systemd_unit_ids       = "${module.common.ignition_systemd_unit_ids}"
}

resource "local_file" "etcd-ign" {
  content  = "${module.etcd.ignition_config}"
  filename = "config_drives/etcd.ign"
}

module "haproxy" {
  source = "../../modules/config/haproxy"
  ignition_file_ids = []
  systemd_unit_ids = "${module.common.ignition_systemd_unit_ids}"
  backend_servers_map = {
    bootstrap = "10.100.100.101:6443"
    controller1 = "10.100.100.102:6443"
    controller2 = "10.100.100.103:6443"
  }
  workers_http_map = {
    worker1 = "10.100.150.100:32080"
    worker2 = "10.100.150.101:32080"
  }
  workers_https_map = {
    worker1 = "10.100.150.100:32443"
    worker2 = "10.100.150.101:32443"
  }
}

resource "local_file" "haproxy-ign" {
  content  = "${module.haproxy.ignition_config}"
  filename = "config_drives/haproxy.ign"
}

module "bootstrap" {
  source             = "../../modules/config/node"
  service_cidr       = "${var.service_cluster_ip_range}"
  kubelet_kubeconfig = "${module.bootkube.kubelet-kubeconfig}"
  ignition_file_ids  = "${module.bootkube.ignition-file-ids}"
  systemd_unit_ids   = "${concat(
    module.common.ignition_systemd_unit_ids,
    list(
      module.bootkube.bootkube_systemd_unit_id,
    ),
  )}"
  kube_ca_crt        = "${module.bootkube.kube-ca-crt}"
  node_labels = "node-role.kubernetes.io/master"
  node_taints = "node-role.kubernetes.io/master=:NoSchedule"
  k8s_tag = "${var.k8s_tag}"
  cluster_domain = "${var.cluster_domain}"
}

resource "local_file" "bootstrap-ign" {
  content  = "${module.bootstrap.ignition_config}"
  filename = "config_drives/bootstrap.ign"
}

module "controller" {
  source             = "../../modules/config/node"
  service_cidr       = "${var.service_cluster_ip_range}"
  kubelet_kubeconfig = "${module.bootkube.kubelet-kubeconfig}"
  ignition_file_ids  = []
  systemd_unit_ids   = "${module.common.ignition_systemd_unit_ids}"
  kube_ca_crt        = "${module.bootkube.kube-ca-crt}"
  node_labels = "node-role.kubernetes.io/master"
  node_taints = "node-role.kubernetes.io/master=:NoSchedule"
  k8s_tag = "${var.k8s_tag}"
  cluster_domain = "${var.cluster_domain}"
}

resource "local_file" "controller-ign" {
  content  = "${module.controller.ignition_config}"
  filename = "config_drives/controller.ign"
}

module "worker" {
  source             = "../../modules/config/node"
  service_cidr       = "${var.service_cluster_ip_range}"
  kubelet_kubeconfig = "${module.bootkube.kubelet-kubeconfig}"
  ignition_file_ids  = []
  systemd_unit_ids   = "${module.common.ignition_systemd_unit_ids}"
  kube_ca_crt        = "${module.bootkube.kube-ca-crt}"
  node_labels = "node-role.kubernetes.io/node"
  node_taints = ""
  k8s_tag = "${var.k8s_tag}"
  cluster_domain = "${var.cluster_domain}"
}

resource "local_file" "worker-ign" {
  content  = "${module.worker.ignition_config}"
  filename = "config_drives/worker.ign"
}
