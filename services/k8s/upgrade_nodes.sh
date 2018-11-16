#!/usr/bin/env bash

set -euo pipefail

export KUBECONFIG=client_config/kubeconfig

set +e
vagrant destroy --force k8s-upgrader
set -e

for i in {1..3}
do
    kubectl -n kube-system rollout status daemonset kube-apiserver
    kubectl -n kube-system rollout status daemonset kube-proxy
    kubectl -n kube-system rollout status deployment kube-controller-manager
    kubectl -n kube-system rollout status deployment kube-scheduler

    sleep 5
done


for node in controller1 controller2 controller3 worker1 worker2 worker3
do
    echo "Upgrading ${node}..."
    kubectl drain ${node} --ignore-daemonsets --delete-local-data
    set +e
    vagrant destroy --force ${node}
    set -e
    echo "Sleeping for haproxy"
    sleep 10
    kubectl delete node ${node}
    vagrant up ${node}
    echo "Waiting for ${node} to become ready (may wait forever)."
    until kubectl get nodes | grep ${node} | grep Ready | grep -v NotReady; do echo -n "."; sleep 1; done
    echo "Upgrade of ${node} complete."
done

echo "Upgrade complete?"
