#!/usr/bin/env bash

set -euo pipefail

export KUBECONFIG="client_config/kubeconfig"

kubectl drain bootstrap --ignore-daemonsets
set +e
vagrant destroy --force bootstrap
curl -k --silent --retry 1000 --retry-max-time 60 --retry-connrefused https://10.100.100.100:6443/healthz
set -e
kubectl delete node bootstrap

kubectl apply -f examples/tiller-sa.yaml
kubectl apply -f examples/tiller-cluster-role-binding.yaml

helm init --service-account tiller

echo "Waiting for tiller"
until kubectl -n kube-system get pods | grep tiller | grep 1/1 | grep Running; do echo -n "."; sleep 1; done
helm repo update

kubectl apply -f examples/cert-manager-secret.yaml
helm install -f examples/cert-manager-values.yaml stable/cert-manager --name cert-manager
echo "Waiting for cert-manager"
until kubectl -n default get pods | grep cert-manager | grep 1/1 | grep Running; do echo -n "."; sleep 1; done
kubectl apply -f examples/cert-manager-cluster-issuer.yaml

helm install -f examples/nginx-ingress-values.yaml stable/nginx-ingress --name nginx-ingress
echo "Waiting for the ingress controller"
until kubectl -n default get pods | grep nginx-ingress-default-backend | grep 1/1 | grep Running; do echo -n "."; sleep 1; done
until kubectl -n default get pods | grep nginx-ingress-controller | grep 1/1 | grep Running; do echo -n "."; sleep 1; done

helm install -f examples/kube-dashboard-values.yaml stable/kubernetes-dashboard --name kubernetes-dashboard

echo "Cluster bootstrap complete!"
