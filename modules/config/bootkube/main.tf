output "ignition-file-ids" {
  value = [
    "${data.ignition_file.kubeconfig.id}",
    "${data.ignition_file.kubeconfig-kubelet.id}",
    "${data.ignition_file.bootstrap-apiserver.id}",
    "${data.ignition_file.bootstrap-controller-manager.id}",
    "${data.ignition_file.bootstrap-scheduler.id}",
    "${data.ignition_file.csr-approver-role-binding.id}",
    "${data.ignition_file.csr-bootstrap-role-binding.id}",
    "${data.ignition_file.csr-renewal-role-binding.id}",
    "${data.ignition_file.flannel-cfg.id}",
    "${data.ignition_file.flannel-cluster-role-binding.id}",
    "${data.ignition_file.flannel-cluster-role.id}",
    "${data.ignition_file.flannel-sa.id}",
    "${data.ignition_file.flannel.id}",
    "${data.ignition_file.kube-apiserver-secret.id}",
    "${data.ignition_file.kube-apiserver.id}",
    "${data.ignition_file.kube-controller-manager-disruption.id}",
    "${data.ignition_file.kube-controller-manager-role-binding.id}",
    "${data.ignition_file.kube-controller-manager-secret.id}",
    "${data.ignition_file.kube-controller-manager-service-account.id}",
    "${data.ignition_file.kube-controller-manager.id}",
    "${data.ignition_file.kube-dns-deployment.id}",
    "${data.ignition_file.kube-dns-svc.id}",
    "${data.ignition_file.kube-proxy-role-binding.id}",
    "${data.ignition_file.kube-proxy-sa.id}",
    "${data.ignition_file.kube-proxy.id}",
    "${data.ignition_file.kube-scheduler-disruption.id}",
    "${data.ignition_file.kube-scheduler.id}",
    "${data.ignition_file.kube-system-rbac-role-binding.id}",
    "${data.ignition_file.kubeconfig-in-cluster.id}",
    "${data.ignition_file.pod-checkpointer-role-binding.id}",
    "${data.ignition_file.pod-checkpointer-role.id}",
    "${data.ignition_file.pod-checkpointer-sa.id}",
    "${data.ignition_file.pod-checkpointer.id}",
    "${data.ignition_file.ca-key.id}",
    "${data.ignition_file.ca-crt.id}",
    "${data.ignition_file.apiserver-key.id}",
    "${data.ignition_file.apiserver-crt.id}",
    "${data.ignition_file.service-account-key.id}",
    "${data.ignition_file.service-account-pub.id}",
    "${data.ignition_file.admin-key.id}",
    "${data.ignition_file.admin-crt.id}",
    "${data.ignition_file.etcd-client-ca-crt.id}",
    "${data.ignition_file.etcd-server-ca-crt.id}",
    "${data.ignition_file.etcd-peer-ca-crt.id}",
    "${data.ignition_file.etcd-client-key.id}",
    "${data.ignition_file.etcd-client-crt.id}",
    "${data.ignition_file.etcd-server-key.id}",
    "${data.ignition_file.etcd-server-crt.id}",
    "${data.ignition_file.etcd-peer-key.id}",
    "${data.ignition_file.etcd-peer-crt.id}",
  ]
}

output "etcd-ignition-file-ids" {
  value = [
    "${data.ignition_file.etcd-etcd-server-ca-crt.id}",
    "${data.ignition_file.etcd-etcd-server-key.id}",
    "${data.ignition_file.etcd-etcd-server-crt.id}",
    "${data.ignition_file.etcd-etcd-peer-ca-crt.id}",
    "${data.ignition_file.etcd-etcd-peer-key.id}",
    "${data.ignition_file.etcd-etcd-peer-crt.id}",
    "${data.ignition_file.etcd-etcd-client-ca-crt.id}",
    "${data.ignition_file.etcd-etcd-client-key.id}",
    "${data.ignition_file.etcd-etcd-client-crt.id}",
  ]
}

output "admin-kubeconfig" {
  value = "${data.template_file.kubeconfig.rendered}"
}

output "kubelet-kubeconfig" {
  value = "${data.template_file.kubeconfig-kubelet.rendered}"
}

output "kube-ca-crt" {
  value = "${tls_self_signed_cert.kube-ca.cert_pem}"
}

data "template_file" "bootkube-service" {
  template = "${file("${path.module}/data/bootkube.service")}"

  vars {
    assets_dir = "${var.assets_dir}"
  }
}

data "ignition_systemd_unit" "bootkube-service" {
  name    = "bootkube.service"
  content = "${data.template_file.bootkube-service.rendered}"
}

output "bootkube_systemd_unit_id" {
  value = "${data.ignition_systemd_unit.bootkube-service.id}"
}

data "template_file" "cert-manager-secret" {
  template = "${file("${path.module}/data/cert-manager-secret.yaml")}"

  vars {
    ca_crt = "${base64encode(tls_self_signed_cert.kube-ca.cert_pem)}"
    ca_key = "${base64encode(tls_private_key.kube-ca.private_key_pem)}"
  }
}

output "cert-manager-secret" {
  value = "${data.template_file.cert-manager-secret.rendered}"
}
