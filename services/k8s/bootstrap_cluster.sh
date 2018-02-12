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

echo "API is up"

kubectl --kubeconfig=${KUBECONFIG} apply -f client_config/kube-proxy.yaml
kubectl --kubeconfig=${KUBECONFIG} apply -f client_config/canal.yaml

helm init

echo "Helm / tiller initialised. Sleeping for 60 seconds to allow tiller to come up completely"
sleep 60

helm install --name coredns -f client_config/coredns_values.yaml stable/coredns

echo "Cluster bootstrap complete!"
