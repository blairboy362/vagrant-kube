data "template_file" "etcd_service" {
  template = "${file("${path.module}/data/etcd.service")}"

  vars {
    cluster_members = "${join(
            ",",
            formatlist(
                "%s=https://%s:%d",
                keys(var.cluster_map),
                values(var.cluster_map),
                2380)
        )}"
  }
}

data "ignition_systemd_unit" "etcd_service" {
  name = "etcd-member.service"

  dropin {
    name    = "40-etcd-cluster.conf"
    content = "${data.template_file.etcd_service.rendered}"
  }
}

data "ignition_config" "etcd" {
  files = ["${var.etcd_ignition_file_ids}"]

  systemd = [
    "${concat(
      list(
        data.ignition_systemd_unit.etcd_service.id,
      ),
      var.systemd_unit_ids,
    )}"]
}

output "ignition_config" {
  value = "${data.ignition_config.etcd.rendered}"
}
