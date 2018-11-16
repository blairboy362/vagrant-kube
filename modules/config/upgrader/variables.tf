variable "ignition_file_ids" {
  type = "list"
}

variable "systemd_unit_ids" {
  type = "list"
}

variable "assets_dir" {
  type    = "string"
  default = "/opt/bootkube/assets"
}
