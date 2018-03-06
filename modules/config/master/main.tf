module "common" {
  source           = "../common"
  kubelet_token    = "${var.kubelet_token}"
  kube_proxy_token = "${var.kube_proxy_token}"
  master_ip        = "${var.master_ip}"
  cluster_dns_ip   = "${var.cluster_dns_ip}"
  cluster_cidr     = "${var.cluster_cidr}"
  pod_cidr         = "${var.pod_cidr}"
  cluster_domain   = "${var.cluster_domain}"
}

data "template_file" "kubelet_kubeconfig" {
  template = "${file("${path.module}/data/kubelet-kubeconfig")}"

  vars {
    token     = "${var.kubelet_token}"
    master_ip = "${var.master_ip}"
  }
}

data "template_file" "kubelet_service" {
  template = "${file("${path.module}/data/kubelet.service")}"

  vars {
    cluster_dns_ip = "${var.cluster_dns_ip}"
    cluster_domain = "${var.cluster_domain}"
  }
}

data "template_file" "kube_apiserver_yaml" {
  template = "${file("${path.module}/data/kube-apiserver.yaml")}"

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

data "template_file" "kube_controller_yaml" {
  template = "${file("${path.module}/data/kube-controller.yaml")}"

  vars {
    pod_cidr  = "${var.pod_cidr}"
    master_ip = "${var.master_ip}"
  }
}

data "template_file" "kube_scheduler_yaml" {
  template = "${file("${path.module}/data/kube-scheduler.yaml")}"

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

data "ignition_file" "ca_key" {
  filesystem = "root"
  path       = "/etc/kubernetes/ca.key"

  content {
    content = "${file("${path.module}/data/ca.key")}"
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

data "ignition_file" "kubelet_crt" {
  filesystem = "root"
  path       = "/etc/kubernetes/kubelet.crt"

  content {
    content = "${file("${path.module}/data/kubelet.crt")}"
  }
}

data "ignition_file" "kubelet_key" {
  filesystem = "root"
  path       = "/etc/kubernetes/kubelet.key"

  content {
    content = "${file("${path.module}/data/kubelet.key")}"
  }
}

data "ignition_file" "known_tokens" {
  filesystem = "root"
  path       = "/etc/kubernetes/known_tokens.csv"

  content {
    content = "${data.template_file.known_tokens.rendered}"
  }
}

data "ignition_file" "kubelet_kubeconfig" {
  filesystem = "root"
  path       = "/etc/kubernetes/kubelet-kubeconfig"

  content {
    content = "${data.template_file.kubelet_kubeconfig.rendered}"
  }
}

data "ignition_file" "kube_apiserver_yaml" {
  filesystem = "root"
  path       = "/etc/kubernetes/manifests/kube-apiserver.yaml"

  content {
    content = "${data.template_file.kube_apiserver_yaml.rendered}"
  }
}

data "ignition_file" "kube_controller_yaml" {
  filesystem = "root"
  path       = "/etc/kubernetes/manifests/kube-controller.yaml"

  content {
    content = "${data.template_file.kube_controller_yaml.rendered}"
  }
}

data "ignition_file" "kube_scheduler_yaml" {
  filesystem = "root"
  path       = "/etc/kubernetes/manifests/kube-scheduler.yaml"

  content {
    content = "${data.template_file.kube_scheduler_yaml.rendered}"
  }
}

data "ignition_systemd_unit" "kubelet_service" {
  name    = "kubelet.service"
  content = "${data.template_file.kubelet_service.rendered}"
}

data "ignition_config" "master" {
  files = [
    "${concat(
            "${module.common.ignition_file_ids}",
            list(
                "${data.ignition_file.ca_key.id}",
                "${data.ignition_file.token_crt.id}",
                "${data.ignition_file.token_key.id}",
                "${data.ignition_file.apiserver_crt.id}",
                "${data.ignition_file.apiserver_key.id}",
                "${data.ignition_file.kubelet_crt.id}",
                "${data.ignition_file.kubelet_key.id}",
                "${data.ignition_file.known_tokens.id}",
                "${data.ignition_file.kubelet_kubeconfig.id}",
                "${data.ignition_file.kube_apiserver_yaml.id}",
                "${data.ignition_file.kube_controller_yaml.id}",
                "${data.ignition_file.kube_scheduler_yaml.id}",
            ),
        )}",
  ]

  systemd = [
    "${concat(
            "${module.common.ignition_systemd_unit_ids}",
            list(
              "${data.ignition_systemd_unit.kubelet_service.id}",
            )
        )}",
  ]
}

output "ignition_config" {
  value = "${data.ignition_config.master.rendered}"
}
