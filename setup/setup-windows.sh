#!/bin/bash

echo "Installing Toolchain..."
echo "Installing Arkade"
curl -sLS https://get.arkade.dev | sh

echo "Please add $HOME/.arkade/bin to your PATH."

echo "Installing Tilt"
arkade get tilt

echo "Installing Helm"
arkade get helm

echo "Installing Kubectl"
arkade get kubectl

echo "Installing Kustomize"
arkade get kustomize

echo "Installing K9s"
arkade get k9s

already_installed=" Command Exists"
not_installed=" Command Does Not Exist"

check_choco_installation() {
	if choco list --lo --limit-output -e $1 == ""; then
		echo "$1$not_installed"
	else
		echo "$1$already_installed"
	fi
}

if [[ "$(check_choco_installation docker-desktop)" == "docker$not_installed" ]]; then
	choco install docker-desktop -y
fi

if [[ "$(check_choco_installation k3d)" == "k3d$not_installed" ]]; then
	choco install k3d -y
fi

if [[ "$(check_choco_installation age.portable)" == "age.portable$not_installed" ]]; then
	choco install age.portable -y
fi

if [[ "$(check_choco_installation sops)" == "sops$not_installed" ]]; then
	choco install sops -y
fi

if [[ "$(check_choco_installation protoc)" == "protoc$not_installed" ]]; then
	choco install protoc -y
fi

echo "Creating Local Cluster"
k3d cluster create dead-letter --port "1337:80@loadbalancer"
