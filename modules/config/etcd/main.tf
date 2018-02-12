module "common" {
  source           = "../common"
  kubelet_token    = "${var.kubelet_token}"
  kube_proxy_token = "${var.kube_proxy_token}"
  master_ip        = "${var.master_ip}"
  cluster_dns_ip   = "${var.cluster_dns_ip}"
  cluster_cidr     = "${var.cluster_cidr}"
  pod_cidr         = "${var.pod_cidr}"
  cluster_domain   = "${var.cluster_domain}"
}

data "template_file" "etcd_manifest" {
  template = "${file("${path.module}/data/etcd.manifest")}"

  vars {
    node_name       = "${var.node_name}"
    node_ip         = "${var.node_ip}"
    cluster_members = "${var.cluster_members}"

    cluster_members = "${join(
            ",",
            "${formatlist(
                "%s=http://%s:%d",
                "${keys("${var.cluster_map}")}",
                "${values("${var.cluster_map}")}",
                2380)}"
        )}"
  }
}

data "ignition_file" "etcd_manifest" {
  filesystem = "root"
  path       = "/etc/kubernetes/manifests/etcd.manifest"

  content {
    content = "${data.template_file.etcd_manifest.rendered}"
  }
}

data "ignition_config" "etcd" {
  files = [
    "${concat(
            "${module.common.ignition_file_ids}",
            list(
                "${data.ignition_file.etcd_manifest.id}",
            ),
        )}",
  ]

  systemd = [
    "${concat(
            "${module.common.ignition_systemd_unit_ids}",
        )}",
  ]
}

output "ignition_config" {
  value = "${data.ignition_config.etcd.rendered}"
}
