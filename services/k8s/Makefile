.PHONY: bootstrap clean config down prepare ssl-certs up

bootstrap: up
	./bootstrap_cluster.sh

up: config
	vagrant up etcd1 master worker1

down:
	-vagrant destroy --force

config: prepare ssl-certs
	terraform apply
	terraform output etcd1 > config_drives/etcd1.ign
	terraform output etcd2 > config_drives/etcd2.ign
	terraform output etcd3 > config_drives/etcd3.ign
	terraform output master > config_drives/master.ign
	terraform output worker > config_drives/worker.ign
	terraform output client_kubeconfig > client_config/kubeconfig
	terraform output canal_yaml > client_config/canal.yaml
	terraform output coredns_values_yaml > client_config/coredns_values.yaml
	terraform output kube_proxy_yaml > client_config/kube-proxy.yaml
	terraform output kube_dashboard_values_yaml > client_config/kube-dashboard_values.yaml
	cp ../../modules/config/client/data/nginx-ingress_values.yaml client_config/nginx-ingress_values.yaml

clean: down
	-rm config_drives/*ign config_drives/*merged *backup client_config/*
	-rm ../../modules/config/common/data/*.crt
	-rm ../../modules/config/common/data/*.key
	-rm ../../modules/config/master/data/*.crt
	-rm ../../modules/config/master/data/*.key

prepare:
	mkdir -p config_drives client_config

ssl-certs:
	cd ssl_certs &&  ./generate_certs.sh
	cp ssl_certs/ca.crt client_config/
	mv ssl_certs/ca.crt ../../modules/config/common/data/ca.crt
	mv ssl_certs/token.crt ../../modules/config/master/data/token.crt
	mv ssl_certs/token.key ../../modules/config/master/data/token.key
	mv ssl_certs/apiserver.crt ../../modules/config/master/data/apiserver.crt
	mv ssl_certs/apiserver.key ../../modules/config/master/data/apiserver.key
	mv ssl_certs/kubelet.crt ../../modules/config/common/data/kubelet.crt
	mv ssl_certs/kubelet.key ../../modules/config/common/data/kubelet.key
	mv ssl_certs/admin.crt ssl_certs/admin.key client_config/
