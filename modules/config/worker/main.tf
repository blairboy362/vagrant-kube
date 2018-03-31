module "common" {
  source       = "../common"
  cluster_cidr = "${var.cluster_cidr}"
}

data "template_file" "kubelet_kubeconfig" {
  template = "${file("${path.module}/data/kubelet-kubeconfig")}"

  vars {
    token     = "${var.kubelet_token}"
    master_ip = "${var.master_ip}"
  }
}

data "template_file" "kubelet_service" {
  template = "${file("${path.module}/data/kubelet.service")}"

  vars {
    cluster_dns_ip = "${var.cluster_dns_ip}"
    cluster_domain = "${var.cluster_domain}"
  }
}

data "ignition_file" "kubelet_kubeconfig" {
  filesystem = "root"
  path       = "/etc/kubernetes/kubelet-bootstrap-kubeconfig"

  content {
    content = "${data.template_file.kubelet_kubeconfig.rendered}"
  }
}

data "ignition_systemd_unit" "kubelet_service" {
  name    = "kubelet.service"
  content = "${data.template_file.kubelet_service.rendered}"
}

data "ignition_config" "worker" {
  files = [
    "${concat(
            "${module.common.ignition_file_ids}",
            list(
                "${data.ignition_file.kubelet_kubeconfig.id}",
            ),
        )}",
  ]

  systemd = [
    "${concat(
            "${module.common.ignition_systemd_unit_ids}",
            list(
              "${data.ignition_systemd_unit.kubelet_service.id}",
            )
        )}",
  ]
}

output "ignition_config" {
  value = "${data.ignition_config.worker.rendered}"
}
