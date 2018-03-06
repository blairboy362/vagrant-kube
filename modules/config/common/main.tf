data "template_file" "node_ip_sh" {
  template = "${file("${path.module}/data/node_ip.sh")}"

  vars {
    cluster_cidr = "${var.cluster_cidr}"
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

data "ignition_systemd_unit" "kube_server_service" {
  name    = "kube-server.service"
  content = "${file("${path.module}/data/kube-server.service")}"
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
    "${data.ignition_file.ca_crt.id}",
    "${data.ignition_file.node_ip_sh.id}",
  ]
}

output "ignition_systemd_unit_ids" {
  value = [
    "${data.ignition_systemd_unit.kube_server_service.id}",
    "${data.ignition_systemd_unit.docker_service.id}",
  ]
}
