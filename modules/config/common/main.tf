data "template_file" "kubelet_kubeconfig" {
  template = "${file("${path.module}/data/kubelet-kubeconfig")}"

  vars {
    TOKEN     = "${var.kubelet_token}"
    master_ip = "${var.master_ip}"
  }
}

data "template_file" "kube_proxy_kubeconfig" {
  template = "${file("${path.module}/data/kube-proxy-kubeconfig")}"

  vars {
    TOKEN     = "${var.kube_proxy_token}"
    master_ip = "${var.master_ip}"
  }
}

data "template_file" "kubelet_service" {
  template = "${file("${path.module}/data/kubelet.service")}"

  vars {
    cluster_dns_ip = "${var.cluster_dns_ip}"
  }
}

data "template_file" "node_ip_sh" {
  template = "${file("${path.module}/data/node_ip.sh")}"

  vars {
    cluster_cidr = "${var.cluster_cidr}"
  }
}

data "template_file" "kube_proxy_config" {
  template = "${file("${path.module}/data/kube-proxy-config.yaml")}"

  vars {
    pod_cidr = "${var.pod_cidr}"
  }
}

data "ignition_file" "kubelet_kubeconfig" {
  filesystem = "root"
  path       = "/etc/kubernetes/kubelet-kubeconfig"

  content {
    content = "${data.template_file.kubelet_kubeconfig.rendered}"
  }
}

data "ignition_file" "kube_proxy_kubeconfig" {
  filesystem = "root"
  path       = "/etc/kubernetes/kube-proxy-kubeconfig"

  content {
    content = "${data.template_file.kube_proxy_kubeconfig.rendered}"
  }
}

data "ignition_file" "ca_crt" {
  filesystem = "root"
  path       = "/etc/kubernetes/ca.crt"

  content {
    content = "${file("${path.module}/data/ca.crt")}"
  }
}

data "ignition_file" "node_ip_sh" {
  filesystem = "root"
  path       = "/opt/bootstrap/node_ip.sh"

  content {
    content = "${data.template_file.node_ip_sh.rendered}"
  }
}

data "ignition_file" "kube_proxy_config" {
  filesystem = "root"
  path       = "/etc/kubernetes/kube-proxy-config.yaml"

  content {
    content = "${data.template_file.kube_proxy_config.rendered}"
  }
}

data "ignition_systemd_unit" "kube_server_service" {
  name    = "kube-server.service"
  content = "${file("${path.module}/data/kube-server.service")}"
}

data "ignition_systemd_unit" "kubelet_service" {
  name    = "kubelet.service"
  content = "${data.template_file.kubelet_service.rendered}"
}

data "ignition_systemd_unit" "docker_service" {
  name = "docker.service"

  dropin {
    name    = "50-docker-options.conf"
    content = "${file("${path.module}/data/50-docker-options.conf")}"
  }
}

output "ignition_file_ids" {
  value = [
    "${data.ignition_file.kubelet_kubeconfig.id}",
    "${data.ignition_file.kube_proxy_kubeconfig.id}",
    "${data.ignition_file.ca_crt.id}",
    "${data.ignition_file.node_ip_sh.id}",
    "${data.ignition_file.kube_proxy_config.id}",
  ]
}

output "ignition_systemd_unit_ids" {
  value = [
    "${data.ignition_systemd_unit.kube_server_service.id}",
    "${data.ignition_systemd_unit.kubelet_service.id}",
    "${data.ignition_systemd_unit.docker_service.id}",
  ]
}
