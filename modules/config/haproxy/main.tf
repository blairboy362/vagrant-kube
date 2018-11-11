data "template_file" "haproxy-cfg" {
  template = "${file("${path.module}/data/haproxy.cfg")}"

  vars {
    backend_servers = "${join(
        "\n    ",
        formatlist(
            "server %s %s check",
            keys(var.backend_servers_map),
            values(var.backend_servers_map)
        )
    )}"
    workers_http = "${join(
      "\n    ",
      formatlist(
        "server %s %s check",
        keys(var.workers_http_map),
        values(var.workers_http_map)
      )
    )}"
    workers_https = "${join(
      "\n    ",
      formatlist(
        "server %s %s check",
        keys(var.workers_https_map),
        values(var.workers_https_map)
      )
    )}"
  }
}

data "ignition_file" "haproxy-cfg" {
  filesystem = "root"
  path       = "/etc/haproxy/haproxy.cfg"
  mode       = 416

  content {
    content = "${data.template_file.haproxy-cfg.rendered}"
  }
}

data "ignition_systemd_unit" "haproxy-service" {
  name    = "haproxy.service"
  content = "${file("${path.module}/data/haproxy.service")}"
}

data "ignition_config" "haproxy" {
  files = [
    "${concat(
            var.ignition_file_ids,
            list(
                data.ignition_file.haproxy-cfg.id,
            ),
        )}",
  ]

  systemd = [
    "${concat(
            var.systemd_unit_ids,
            list(
              data.ignition_systemd_unit.haproxy-service.id,
            )
        )}",
  ]
}

output "ignition_config" {
  value = "${data.ignition_config.haproxy.rendered}"
}
