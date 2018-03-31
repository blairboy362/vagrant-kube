module "common" {
  source       = "../common"
  cluster_cidr = "${var.cluster_cidr}"
}

data "template_file" "etcd_service" {
  template = "${file("${path.module}/data/etcd.service")}"

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

data "ignition_systemd_unit" "etcd_service" {
  name    = "etcd.service"
  content = "${data.template_file.etcd_service.rendered}"
}

data "ignition_config" "etcd" {
  files = ["${module.common.ignition_file_ids}"]

  systemd = [
    "${concat(
            "${module.common.ignition_systemd_unit_ids}",
            list(
              "${data.ignition_systemd_unit.etcd_service.id}",
            ),
        )}",
  ]
}

output "ignition_config" {
  value = "${data.ignition_config.etcd.rendered}"
}
