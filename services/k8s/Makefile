.PHONY: bootkube-assets bootstrap clean config down prepare up

bootstrap: up
	vagrant up bootstrap

up: config
	vagrant up etcd1 haproxy controller1 controller2 controller3 worker1 worker2 worker3

clean: down
	terraform destroy
	-rm config_drives/*ign config_drives/*merged *backup client_config/*
	-rm -rf bootkube_assets

config: prepare
	terraform apply

bootkube-assets: prepare
	docker run --rm \
		-v $(CURDIR)/bootkube_assets:/assets:rw \
		quay.io/coreos/bootkube:v0.13.0 \
		/bootkube render \
			--api-servers https://10.100.100.100:6443 \
			--asset-dir /assets \
			--etcd-servers https://10.100.50.100:2379 \
			--pod-cidr 10.120.0.0/16 \
			--service-cidr 10.110.0.0/16
	sudo chown -R daniel:daniel bootkube_assets

down:
	-vagrant destroy --force

prepare:
	mkdir -p config_drives client_config bootkube_assets
