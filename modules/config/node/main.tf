data "template_file" "kubelet_service" {
  template = "${file("${path.module}/data/kubelet.service")}"

  vars {
    dns_service_ip = "${cidrhost(var.service_cidr, 10)}"
    node_labels = "${var.node_labels}"
    node_taints = "${var.node_taints}"
    cluster_domain = "${var.cluster_domain}"
    k8s_tag = "${var.k8s_tag}"
  }
}

data "ignition_file" "kubelet_kubeconfig" {
  filesystem = "root"
  path       = "/etc/kubernetes/kubeconfig"
  mode       = 416

  content {
    content = "${var.kubelet_kubeconfig}"
  }
}

data "ignition_file" "kube-ca-crt" {
  filesystem = "root"
  path       = "/etc/kubernetes/ca.crt"
  mode       = 416

  content {
    content = "${var.kube_ca_crt}"
  }
}

data "ignition_systemd_unit" "kubelet_service" {
  name    = "kubelet.service"
  content = "${data.template_file.kubelet_service.rendered}"
}

data "ignition_config" "node" {
  files = [
    "${concat(
            var.ignition_file_ids,
            list(
                data.ignition_file.kubelet_kubeconfig.id,
                data.ignition_file.kube-ca-crt.id,
            ),
        )}",
  ]

  systemd = [
    "${concat(
            var.systemd_unit_ids,
            list(
              data.ignition_systemd_unit.kubelet_service.id,
            )
        )}",
  ]
}

output "ignition_config" {
  value = "${data.ignition_config.node.rendered}"
}
