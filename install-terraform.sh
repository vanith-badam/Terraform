#!/bin/bash
# 
# Date: 12-July-2025
#
# Ensure that your system is up to date and that you have installed the gnupg and software-properties-common packages.
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common &>/dev/null
#
# Install HashiCorp's GPG key
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
#
# Verify the GPG key's fingerprint.
gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
#
# Add the official HashiCorp repository to your system.
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
#
#Update apt to download the package information from the HashiCorp repository.
sudo apt update -y >/dev/null
#
#Install Terraform from the new repository.
#
sudo apt-get install -y terraform >/dev/null
#
#Verify that the installation
#
terraform --version
#
# Enable Terraform tab completion
echo "terraform -install-autocomplete" >> ~/.bashrc

