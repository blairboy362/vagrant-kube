data "template_file" "k8s-upgrader-server" {
  template = "${file("${path.module}/data/k8s-upgrader.service")}"

  vars {
      assets_dir = "${var.assets_dir}"
  }
}

data "ignition_systemd_unit" "k8s-upgrader-server" {
  name    = "k8s-upgrader.service"
  content = "${data.template_file.k8s-upgrader-server.rendered}"
}

data "ignition_config" "upgrader" {
  files = ["${var.ignition_file_ids}"]

  systemd = [
    "${concat(
            var.systemd_unit_ids,
            list(
              data.ignition_systemd_unit.k8s-upgrader-server.id,
            )
        )}",
  ]
}

output "ignition_config" {
  value = "${data.ignition_config.upgrader.rendered}"
}
