# vagrant-kube

I thought it would be a laugh to have a go at setting up a kubernetes cluster from basics.

Requirements (versions installed at time of writing):
* terraform v0.11.10
* vagrant 2.2.0
* virtualbox 5.2.22
* docker 17.05.0-ce, build 89658be
* helm 2.8.1

```
cd services/k8s
terraform init
make up
export KUBECONFIG=$(pwd)/client_config/kubeconfig
watch -n 5 kubectl get all --all-namespaces
./bootstrap_cluster.sh
```

The bootstrap scripts may silently fail to install some components. Sometimes the cluster (and the API server in particular) doesn't come up cleanly and bounces for a few minutes before settling. During that window various components may fail to install (an intermittent issue I haven't bothered to solve yet).
