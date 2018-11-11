data "ignition_systemd_unit" "docker_service" {
  name = "docker.service"

  dropin {
    name    = "50-docker-options.conf"
    content = "${file("${path.module}/data/50-docker-options.conf")}"
  }
}

output "ignition_systemd_unit_ids" {
  value = [
    "${data.ignition_systemd_unit.docker_service.id}",
  ]
}
