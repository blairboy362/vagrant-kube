.PHONY: clean config down prepare up

config: prepare
	terraform apply
	terraform output etcd1 > config_drives/etcd1.ign
	terraform output etcd2 > config_drives/etcd2.ign
	terraform output etcd3 > config_drives/etcd3.ign
	terraform output master > config_drives/master.ign
	terraform output worker > config_drives/worker.ign
	terraform output client_kubeconfig > client_config/kubeconfig
	terraform output canal_yaml > client_config/canal.yaml
	terraform output coredns_yaml > client_config/coredns.yaml
	terraform output kube_dns_yaml > client_config/kube-dns.yaml
	terraform output kube_proxy_yaml > client_config/kube-proxy.yaml

clean: down
	-rm config_drives/*ign config_drives/*merged *backup client_config/*

up: config
	vagrant up

down:
	-vagrant destroy --force

prepare:
	mkdir -p config_drives client_config
