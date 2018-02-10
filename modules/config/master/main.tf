module "common" {
  source           = "../common"
  kubelet_token    = "${var.kubelet_token}"
  kube_proxy_token = "${var.kube_proxy_token}"
  master_ip        = "${var.master_ip}"
  cluster_dns_ip   = "${var.cluster_dns_ip}"
  cluster_cidr     = "${var.cluster_cidr}"
  pod_cidr         = "${var.pod_cidr}"
}

data "template_file" "apiserver_manifest" {
  template = "${file("${path.module}/data/apiserver.manifest")}"

  vars {
    service_cluster_ip_range = "${var.service_cluster_ip_range}"

    etcd_servers = "${join(
            ",",
            "${formatlist(
                "http://%s:%d",
                "${var.etcd_servers}",
                2379
            )}"
        )}"

    master_ip = "${var.master_ip}"
  }
}

data "template_file" "controller_manifest" {
  template = "${file("${path.module}/data/controller.manifest")}"

  vars {
    pod_cidr  = "${var.pod_cidr}"
    master_ip = "${var.master_ip}"
  }
}

data "template_file" "scheduler_manifest" {
  template = "${file("${path.module}/data/scheduler.manifest")}"

  vars {
    master_ip = "${var.master_ip}"
  }
}

data "template_file" "known_tokens" {
  template = "${file("${path.module}/data/known_tokens.csv")}"

  vars {
    kubelet_token    = "${var.kubelet_token}"
    kube_proxy_token = "${var.kube_proxy_token}"
  }
}

data "template_file" "basic_auth" {
  template = "${file("${path.module}/data/basic_auth.csv")}"

  vars {
    admin_token = "${var.admin_token}"
  }
}

data "ignition_file" "apiserver_manifest" {
  filesystem = "root"
  path       = "/etc/kubernetes/manifests/apiserver.manifest"

  content {
    content = "${data.template_file.apiserver_manifest.rendered}"
  }
}

data "ignition_file" "scheduler_manifest" {
  filesystem = "root"
  path       = "/etc/kubernetes/manifests/scheduler.manifest"

  content {
    content = "${data.template_file.scheduler_manifest.rendered}"
  }
}

data "ignition_file" "controller_manifest" {
  filesystem = "root"
  path       = "/etc/kubernetes/manifests/controller.manifest"

  content {
    content = "${data.template_file.controller_manifest.rendered}"
  }
}

data "ignition_file" "token_crt" {
  filesystem = "root"
  path       = "/etc/kubernetes/token.crt"

  content {
    content = "${file("${path.module}/data/token.crt")}"
  }
}

data "ignition_file" "token_key" {
  filesystem = "root"
  path       = "/etc/kubernetes/token.key"

  content {
    content = "${file("${path.module}/data/token.key")}"
  }
}

data "ignition_file" "apiserver_crt" {
  filesystem = "root"
  path       = "/etc/kubernetes/apiserver.crt"

  content {
    content = "${file("${path.module}/data/apiserver.crt")}"
  }
}

data "ignition_file" "apiserver_key" {
  filesystem = "root"
  path       = "/etc/kubernetes/apiserver.key"

  content {
    content = "${file("${path.module}/data/apiserver.key")}"
  }
}

data "ignition_file" "known_tokens" {
  filesystem = "root"
  path       = "/etc/kubernetes/known_tokens.csv"

  content {
    content = "${data.template_file.known_tokens.rendered}"
  }
}

data "ignition_file" "basic_auth" {
  filesystem = "root"
  path       = "/etc/kubernetes/basic_auth.csv"

  content {
    content = "${data.template_file.basic_auth.rendered}"
  }
}

data "ignition_config" "master" {
  files = [
    "${concat(
            "${module.common.ignition_file_ids}",
            list(
                "${data.ignition_file.apiserver_manifest.id}",
                "${data.ignition_file.scheduler_manifest.id}",
                "${data.ignition_file.controller_manifest.id}",
                "${data.ignition_file.token_crt.id}",
                "${data.ignition_file.token_key.id}",
                "${data.ignition_file.apiserver_crt.id}",
                "${data.ignition_file.apiserver_key.id}",
                "${data.ignition_file.known_tokens.id}",
                "${data.ignition_file.basic_auth.id}",
            ),
        )}",
  ]

  systemd = [
    "${concat(
            "${module.common.ignition_systemd_unit_ids}",
        )}",
  ]
}

output "ignition_config" {
  value = "${data.ignition_config.master.rendered}"
}
