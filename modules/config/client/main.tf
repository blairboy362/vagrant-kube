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
  }
}

output "canal_yaml" {
  value = "${data.template_file.canal_yaml.rendered}"
}

data "template_file" "coredns_yaml" {
  template = "${file("${path.module}/data/coredns.yaml")}"

  vars {
    cluster_domain           = "${var.cluster_domain}"
    service_cluster_ip_range = "${var.service_cluster_ip_range}"
    cluster_dns_ip           = "${var.cluster_dns_ip}"
  }
}

output "coredns_yaml" {
  value = "${data.template_file.coredns_yaml.rendered}"
}

data "template_file" "kube_dns_yaml" {
  template = "${file("${path.module}/data/kube-dns.yaml")}"

  vars {
    cluster_dns_ip = "${var.cluster_dns_ip}"
    cluster_domain = "${var.cluster_domain}"
  }
}

output "kube_dns_yaml" {
  value = "${data.template_file.kube_dns_yaml.rendered}"
}
