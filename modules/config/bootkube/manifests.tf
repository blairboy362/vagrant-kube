data "ignition_file" "csr-approver-role-binding" {
  filesystem = "root"
  path       = "${var.assets_dir}/manifests/csr-approver-role-binding.yaml"
  mode       = 416

  content {
    content = "${file("${path.module}/data/manifests/csr-approver-role-binding.yaml")}"
  }
}

data "ignition_file" "csr-bootstrap-role-binding" {
  filesystem = "root"
  path       = "${var.assets_dir}/manifests/csr-bootstrap-role-binding.yaml"
  mode       = 416

  content {
    content = "${file("${path.module}/data/manifests/csr-bootstrap-role-binding.yaml")}"
  }
}

data "ignition_file" "csr-renewal-role-binding" {
  filesystem = "root"
  path       = "${var.assets_dir}/manifests/csr-renewal-role-binding.yaml"
  mode       = 416

  content {
    content = "${file("${path.module}/data/manifests/csr-renewal-role-binding.yaml")}"
  }
}

data "template_file" "flannel-cfg" {
  template = "${file("${path.module}/data/manifests/flannel-cfg.yaml")}"

  vars {
    pod_cidr = "${var.pod_cidr}"
  }
}

data "ignition_file" "flannel-cfg" {
  filesystem = "root"
  path       = "${var.assets_dir}/manifests/flannel-cfg.yaml"
  mode       = 416

  content {
    content = "${data.template_file.flannel-cfg.rendered}"
  }
}

data "ignition_file" "flannel-cluster-role-binding" {
  filesystem = "root"
  path       = "${var.assets_dir}/manifests/flannel-cluster-role-binding.yaml"
  mode       = 416

  content {
    content = "${file("${path.module}/data/manifests/flannel-cluster-role-binding.yaml")}"
  }
}

data "ignition_file" "flannel-cluster-role" {
  filesystem = "root"
  path       = "${var.assets_dir}/manifests/flannel-cluster-role.yaml"
  mode       = 416

  content {
    content = "${file("${path.module}/data/manifests/flannel-cluster-role.yaml")}"
  }
}

data "ignition_file" "flannel-sa" {
  filesystem = "root"
  path       = "${var.assets_dir}/manifests/flannel-sa.yaml"
  mode       = 416

  content {
    content = "${file("${path.module}/data/manifests/flannel-sa.yaml")}"
  }
}

data "ignition_file" "flannel" {
  filesystem = "root"
  path       = "${var.assets_dir}/manifests/flannel.yaml"
  mode       = 416

  content {
    content = "${file("${path.module}/data/manifests/flannel.yaml")}"
  }
}

data "template_file" "kube-apiserver-secret" {
  template = "${file("${path.module}/data/manifests/kube-apiserver-secret.yaml")}"

  vars {
    apiserver_crt       = "${base64encode(tls_locally_signed_cert.apiserver.cert_pem)}"
    apiserver_key       = "${base64encode(tls_private_key.apiserver.private_key_pem)}"
    ca_data             = "${base64encode(tls_self_signed_cert.kube-ca.cert_pem)}"
    etcd_ca_crt         = "${base64encode(tls_self_signed_cert.etcd-ca.cert_pem)}"
    etcd_client_crt     = "${base64encode(tls_locally_signed_cert.etcd-client.cert_pem)}"
    etcd_client_key     = "${base64encode(tls_private_key.etcd-client.private_key_pem)}"
    service_account_pub = "${base64encode(tls_private_key.service-account.public_key_pem)}"
  }
}

data "ignition_file" "kube-apiserver-secret" {
  filesystem = "root"
  path       = "${var.assets_dir}/manifests/kube-apiserver-secret.yaml"
  mode       = 416

  content {
    content = "${data.template_file.kube-apiserver-secret.rendered}"
  }
}

data "template_file" "kube-apiserver" {
  template = "${file("${path.module}/data/manifests/kube-apiserver.yaml")}"

  vars {
    etcd_servers = "${join(",", formatlist("https://%s:%s", var.etcd_servers, var.etcd_port))}"
    service_cidr = "${var.service_cidr}"
    apiserver_address = "${var.apiserver_address}"
    k8s_tag = "${var.k8s_tag}"
  }
}

data "ignition_file" "kube-apiserver" {
  filesystem = "root"
  path       = "${var.assets_dir}/manifests/kube-apiserver.yaml"
  mode       = 416

  content {
    content = "${data.template_file.kube-apiserver.rendered}"
  }
}

data "ignition_file" "kube-controller-manager-disruption" {
  filesystem = "root"
  path       = "${var.assets_dir}/manifests/kube-controller-manager-disruption.yaml"
  mode       = 416

  content {
    content = "${file("${path.module}/data/manifests/kube-controller-manager-disruption.yaml")}"
  }
}

data "ignition_file" "kube-controller-manager-role-binding" {
  filesystem = "root"
  path       = "${var.assets_dir}/manifests/kube-controller-manager-role-binding.yaml"
  mode       = 416

  content {
    content = "${file("${path.module}/data/manifests/kube-controller-manager-role-binding.yaml")}"
  }
}

data "template_file" "kube-controller-manager-secret" {
  template = "${file("${path.module}/data/manifests/kube-controller-manager-secret.yaml")}"

  vars {
    ca_crt              = "${base64encode(tls_self_signed_cert.kube-ca.cert_pem)}"
    ca_key              = "${base64encode(tls_private_key.kube-ca.private_key_pem)}"
    service_account_key = "${base64encode(tls_private_key.service-account.private_key_pem)}"
  }
}

data "ignition_file" "kube-controller-manager-secret" {
  filesystem = "root"
  path       = "${var.assets_dir}/manifests/kube-controller-manager-secret.yaml"
  mode       = 416

  content {
    content = "${data.template_file.kube-controller-manager-secret.rendered}"
  }
}

data "ignition_file" "kube-controller-manager-service-account" {
  filesystem = "root"
  path       = "${var.assets_dir}/manifests/kube-controller-manager-service-account.yaml"
  mode       = 416

  content {
    content = "${file("${path.module}/data/manifests/kube-controller-manager-service-account.yaml")}"
  }
}

data "template_file" "kube-controller-manager" {
  template = "${file("${path.module}/data/manifests/kube-controller-manager.yaml")}"

  vars {
    pod_cidr     = "${var.pod_cidr}"
    service_cidr = "${var.service_cidr}"
    k8s_tag = "${var.k8s_tag}"
  }
}

data "ignition_file" "kube-controller-manager" {
  filesystem = "root"
  path       = "${var.assets_dir}/manifests/kube-controller-manager.yaml"
  mode       = 416

  content {
    content = "${data.template_file.kube-controller-manager.rendered}"
  }
}

data "template_file" "kube-dns-deployment" {
  template = "${file("${path.module}/data/manifests/kube-dns-deployment.yaml")}"

  vars {
    cluster_domain = "${var.cluster_domain_suffix}"
  }
}

data "ignition_file" "kube-dns-deployment" {
  filesystem = "root"
  path       = "${var.assets_dir}/manifests/kube-dns-deployment.yaml"
  mode       = 416

  content {
    content = "${data.template_file.kube-dns-deployment.rendered}"
  }
}

data "template_file" "kube-dns-svc" {
  template = "${file("${path.module}/data/manifests/kube-dns-svc.yaml")}"

  vars {
    dns_service_ip = "${cidrhost(var.service_cidr, 10)}"
  }
}

data "ignition_file" "kube-dns-svc" {
  filesystem = "root"
  path       = "${var.assets_dir}/manifests/kube-dns-svc.yaml"
  mode       = 416

  content {
    content = "${data.template_file.kube-dns-svc.rendered}"
  }
}

data "ignition_file" "kube-proxy-role-binding" {
  filesystem = "root"
  path       = "${var.assets_dir}/manifests/kube-proxy-role-binding.yaml"
  mode       = 416

  content {
    content = "${file("${path.module}/data/manifests/kube-proxy-role-binding.yaml")}"
  }
}

data "ignition_file" "kube-proxy-sa" {
  filesystem = "root"
  path       = "${var.assets_dir}/manifests/kube-proxy-sa.yaml"
  mode       = 416

  content {
    content = "${file("${path.module}/data/manifests/kube-proxy-sa.yaml")}"
  }
}

data "template_file" "kube-proxy" {
  template = "${file("${path.module}/data/manifests/kube-proxy.yaml")}"

  vars {
    k8s_tag = "${var.k8s_tag}"
    pod_cidr = "${var.pod_cidr}"
  }
}

data "ignition_file" "kube-proxy" {
  filesystem = "root"
  path       = "${var.assets_dir}/manifests/kube-proxy.yaml"
  mode       = 416

  content {
    content = "${data.template_file.kube-proxy.rendered}"
  }
}

data "ignition_file" "kube-scheduler-disruption" {
  filesystem = "root"
  path       = "${var.assets_dir}/manifests/kube-scheduler-disruption.yaml"
  mode       = 416

  content {
    content = "${file("${path.module}/data/manifests/kube-scheduler-disruption.yaml")}"
  }
}

data "template_file" "kube-scheduler" {
  template = "${file("${path.module}/data/manifests/kube-scheduler.yaml")}"

  vars {
    k8s_tag = "${var.k8s_tag}"
  }
}

data "ignition_file" "kube-scheduler" {
  filesystem = "root"
  path       = "${var.assets_dir}/manifests/kube-scheduler.yaml"
  mode       = 416

  content {
    content = "${data.template_file.kube-scheduler.rendered}"
  }
}

data "ignition_file" "kube-system-rbac-role-binding" {
  filesystem = "root"
  path       = "${var.assets_dir}/manifests/kube-system-rbac-role-binding.yaml"
  mode       = 416

  content {
    content = "${file("${path.module}/data/manifests/kube-system-rbac-role-binding.yaml")}"
  }
}

data "template_file" "kubeconfig-in-cluster" {
  template = "${file("${path.module}/data/manifests/kubeconfig-in-cluster.yaml")}"

  vars {
    apiserver_address = "${var.apiserver_address}"
  }
}

data "ignition_file" "kubeconfig-in-cluster" {
  filesystem = "root"
  path       = "${var.assets_dir}/manifests/kubeconfig-in-cluster.yaml"
  mode       = 416

  content {
    content = "${data.template_file.kubeconfig-in-cluster.rendered}"
  }
}

data "ignition_file" "pod-checkpointer-role-binding" {
  filesystem = "root"
  path       = "${var.assets_dir}/manifests/pod-checkpointer-role-binding.yaml"
  mode       = 416

  content {
    content = "${file("${path.module}/data/manifests/pod-checkpointer-role-binding.yaml")}"
  }
}

data "ignition_file" "pod-checkpointer-role" {
  filesystem = "root"
  path       = "${var.assets_dir}/manifests/pod-checkpointer-role.yaml"
  mode       = 416

  content {
    content = "${file("${path.module}/data/manifests/pod-checkpointer-role.yaml")}"
  }
}

data "ignition_file" "pod-checkpointer-sa" {
  filesystem = "root"
  path       = "${var.assets_dir}/manifests/pod-checkpointer-sa.yaml"
  mode       = 416

  content {
    content = "${file("${path.module}/data/manifests/pod-checkpointer-sa.yaml")}"
  }
}

data "ignition_file" "pod-checkpointer" {
  filesystem = "root"
  path       = "${var.assets_dir}/manifests/pod-checkpointer.yaml"
  mode       = 416

  content {
    content = "${file("${path.module}/data/manifests/pod-checkpointer.yaml")}"
  }
}
