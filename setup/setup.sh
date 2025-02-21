#!/bin/bash

# Install Toolchain
echo "Installing Toolchain..."
echo "Installing Arkade"
curl -sLS https://get.arkade.dev | sudo sh

echo "Installing Tilt"
arkade get tilt
sudo mv /home/$USER/.arkade/bin/tilt /usr/local/bin/

echo "Installing Helm"
arkade get helm
sudo mv /home/$USER/.arkade/bin/helm /usr/local/bin/

echo "Installing Kubectl"
arkade get kubectl
sudo mv /home/$USER/.arkade/bin/kubectl /usr/local/bin

echo "Installing Kustomize"
arkade get kustomize
sudo mv /home/$USER/.arkade/bin/kustomize /usr/local/bin

echo "Installing K9s"
arkade get k9s
sudo mv /home/$USER/.arkade/bin/k9s /usr/local/bin

echo "Installing SOPS"
curl -LO https://github.com/getsops/sops/releases/download/v3.9.4/sops-v3.9.4.linux.amd64
sudo mv sops-v3.9.4.linux.amd64 /usr/local/bin/sops
chmod +x /usr/local/bin/sops

already_installed=" is already installed. Skipping..."
not_installed=" is not installed. Installing..."

check_docker() {
    if command -v docker &>/dev/null; then
        echo "Docker$already_installed"
    else
        echo "Docker$not_installed"
    fi
}

install_docker_mac() {
    if command -v "brew" &>/dev/null; then
        brew install --cask docker
    else
        echo "Homebrew is not installed. Please install Homebrew and try again."
        exit 1
    fi
}

install_docker_debian() {
    sudo apt update && sudo apt install -y ca-certificates curl gnupg

    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo tee /etc/apt/keyrings/docker.asc >/dev/null
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

    sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

install_docker_arch() {
    sudo pacman -Sy --noconfirm docker
}

install_docker_fedora() {
    sudo dnf install -y dnf-plugins-core
    sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

enable_docker() {
    sudo systemctl enable --now docker
    sudo usermod -aG docker $USER
    echo "Docker installed successfully. You may need to restart your session for group changes to take effect."
}

install_docker() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        install_docker_mac
    elif command -v apt &>/dev/null; then
        install_docker_debian
    elif command -v pacman &>/dev/null; then
        install_docker_arch
    elif command -v dnf &>/dev/null; then
        install_docker_fedora
    else
        echo "Unsupported operating system. Please install Docker manually before proceeding."
        exit 1
    fi

    enable_docker
}

docker_installed=$(check_docker)

if [[ "$docker_installed" == "Docker$not_installed" ]]; then
    install_docker
fi

echo "Installing misc toolchain..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    brew install age
elif command -v apt &>/dev/null; then
    sudo apt-get install age
elif command -v pacman &>/dev/null; then
    yay -S age
elif command -v dnf &>/dev/null; then
    sudo dnf install age
else
    echo "Unsupported operating system. Please install toolchain manually before proceeding."
    exit 1
fi

echo "Installing k3d"
wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

echo "Creating Local Cluster"
k3d cluster create dead-letter --port "1337:80@loadbalancer"

# Clone Repositories
