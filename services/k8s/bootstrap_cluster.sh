#!/usr/bin/env bash

export KUBECONFIG="client_config/kubeconfig"

kube_api_up="1"

while [ "${kube_api_up}" != "0" ]
do
    echo "Sleeping waiting for kube api..."
    sleep 2
    curl --fail --silent http://10.100.100.100:8080/healthz > /dev/null
    kube_api_up=$?
done

echo "API is up. Waiting a few minutes for it to settle.."
sleep 300
kubectl --kubeconfig=${KUBECONFIG} apply -f client_config/bootstrap_roles.yaml
kubectl --kubeconfig=${KUBECONFIG} apply -f client_config/kube-proxy.yaml
kubectl --kubeconfig=${KUBECONFIG} apply -f client_config/canal.yaml

helm init --service-account tiller

echo "Helm / tiller initialised. Sleeping for 5 minutes to allow tiller to come up completely"
sleep 300

helm install -f client_config/coredns_values.yaml stable/coredns --name coredns
helm install -f client_config/nginx-ingress_values.yaml stable/nginx-ingress --name nginx-ingress

echo "Sleeping for 10 seconds to let the nginx ingress controller settle..."
sleep 10

helm install -f client_config/kube-dashboard_values.yaml stable/kubernetes-dashboard --name kubernetes-dashboard

echo "Cluster bootstrap complete!"
