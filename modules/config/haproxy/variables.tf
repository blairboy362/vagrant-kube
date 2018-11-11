variable "ignition_file_ids" {
  type = "list"
}

variable "systemd_unit_ids" {
  type = "list"
}

variable "backend_servers_map" {
  type = "map"
}

variable "workers_http_map" {
  type = "map"
}

variable "workers_https_map" {
  type = "map"
}
