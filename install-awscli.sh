#!/bin/bash

# Download the aws cli installation package
sudo apt update -y &>/dev/null #Ensure apt is updated.
sudo apt install curl -y &>/dev/null # Ensure curl package is installed and updated
ls /tmp/awscliv2.zip &>/dev/null
if [ $? -eq 0 ]; then
	echo "###################################################"
	echo "Required AWS CLI Package is already downloaded!"
	echo "###################################################"
	exit 1
else
        echo " "
	echo "Downloading AWS CLI Package!"
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip" &>/dev/null
	exit 1
fi


# Unzip the installation package
sudo apt install unzip -y &>/dev/null #Ensures the unzip binary is installed and updated.
cd /tmp && unzip /tmp/awscliv2.zip &>/dev/null

# Install the aws cli from source code if not installed already
aws --version &>/dev/null
if [ $? -eq 0 ]; then
	echo "AWS CLI is already installed!"
else
	sudo /tmp/aws/install &>/dev/null
	echo "AWS CLI Successfully installed!"
	aws --version 
fi


	






