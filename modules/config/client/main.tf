data "template_file" "kubeconfig" {
  template = "${file("${path.module}/data/kubeconfig")}"

  vars {
    admin_token = "${var.admin_token}"
    master_ip   = "${var.master_ip}"
  }
}

output "kubeconfig" {
  value = "${data.template_file.kubeconfig.rendered}"
}

data "template_file" "canal_yaml" {
  template = "${file("${path.module}/data/canal.yaml")}"

  vars {
    pod_cidr = "${var.pod_cidr}"
    master_ip = "${var.master_ip}"
  }
}

output "canal_yaml" {
  value = "${data.template_file.canal_yaml.rendered}"
}

data "template_file" "coredns_values_yaml" {
  template = "${file("${path.module}/data/coredns_values.yaml")}"

  vars {
    cluster_domain           = "${var.cluster_domain}"
    service_cluster_ip_range = "${var.service_cluster_ip_range}"
    cluster_dns_ip           = "${var.cluster_dns_ip}"
  }
}

output "coredns_values_yaml" {
  value = "${data.template_file.coredns_values_yaml.rendered}"
}

data "template_file" "kube_proxy_yaml" {
  template = "${file("${path.module}/data/kube-proxy.yaml")}"

  vars {
    master_ip = "${var.master_ip}"
    pod_cidr = "${var.pod_cidr}"
  }
}

output "kube_proxy_yaml" {
  value = "${data.template_file.kube_proxy_yaml.rendered}"
}

data "template_file" "kube_dashboard_values_yaml" {
  template = "${file("${path.module}/data/kube-dashboard_values.yaml")}"

  vars {
    cluster_domain           = "${var.cluster_domain}"
  }
}

output "kube_dashboard_values_yaml" {
  value = "${data.template_file.kube_dashboard_values_yaml.rendered}"
}
