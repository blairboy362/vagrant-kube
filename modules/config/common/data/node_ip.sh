#!/usr/bin/env bash
node_ip=""
while [ -z "$${node_ip}" ]
do
    echo "node_ip not set. Sleeping for 5 seconds..."
    sleep 5
    node_ip=$(ip route | grep '${cluster_cidr}' | head -1 | awk '{print $9}')
done

echo "Detected node IP: $${node_ip}"

echo "KUBE_NODE_IP=$${node_ip}" > /run/kube_node_ip.env
