# vagrant-kube

I thought it would be a laugh to have a go at setting up a kubernetes cluster from basics.

Requirements:
* terraform v0.11.3
* vagrant 2.0.2
* virtualbox 5.2.8
* docker 17.05.0-ce, build 89658be

The scripts also use `curl` and `jq`.

```
cd services/k8s
terraform init
make bootstrap
```
The bootstrap scripts may silently fail to install some components. Sometimes the cluster (and the API server in particular) doesn't come up cleanly and bounces for a few minutes before settling. During that window various components may fail to install (an intermittent issue I haven't bothered to solve yet).
