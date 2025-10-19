#!/bin/bash

# Initialize the control plane
sudo kubeadm init \
	--control-plane-endpoint="10.227.4.10:6443" \
	--pod-network-cidr="10.244.0.0/16" \
	--upload-certs \
	--v 5

# install cilium
cilium install --version 1.18.2