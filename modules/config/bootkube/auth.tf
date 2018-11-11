data "template_file" "kubeconfig" {
  template = "${file("${path.module}/data/auth/kubeconfig")}"

  vars {
    apiserver_address = "${var.apiserver_address}"
    ca_data           = "${base64encode(tls_self_signed_cert.kube-ca.cert_pem)}"
    admin_cert_data   = "${base64encode(tls_locally_signed_cert.kubelet.cert_pem)}"
    admin_key_data    = "${base64encode(tls_private_key.kubelet.private_key_pem)}"
  }
}

data "ignition_file" "kubeconfig" {
  filesystem = "root"
  path       = "${var.assets_dir}/auth/kubeconfig"
  mode       = 416

  content {
    content = "${data.template_file.kubeconfig.rendered}"
  }
}

data "template_file" "kubeconfig-kubelet" {
  template = "${file("${path.module}/data/auth/kubeconfig-kubelet")}"

  vars {
    apiserver_address = "${var.apiserver_address}"
    ca_data           = "${base64encode(tls_self_signed_cert.kube-ca.cert_pem)}"
    kubelet_cert_data = "${base64encode(tls_locally_signed_cert.kubelet.cert_pem)}"
    kubelet_key_data  = "${base64encode(tls_private_key.kubelet.private_key_pem)}"
  }
}

data "ignition_file" "kubeconfig-kubelet" {
  filesystem = "root"
  path       = "${var.assets_dir}/auth/kubeconfig-kubelet"
  mode       = 416

  content {
    content = "${data.template_file.kubeconfig-kubelet.rendered}"
  }
}
