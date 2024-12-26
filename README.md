# Terraform_ansible_deployment
# Project Workflow
Infrastructure Setup with Terraform Provision AWS resources: A VPC with a public subnet. An EC2 instance in the public subnet. Security groups to control access to the instance. Application Deployment with Ansible
Install necessary dependencies (Node.js, MongoDB, Nginx). Clone the MERN application repository from repo-https://github.com/UnpredictablePrashant/TravelMemory and set up the frontend and backend.
Nginx Configuration Serve the React frontend. Reverse proxy requests to the backend API.
# Prerequisites
An AWS account with access credentials.
Terraform installed on EC2 workspace.
Ansible installed on EC2 workspace.
An existing AWS key pair for SSH access to the EC2 instance.
# Steps
Configure AWS CLI and Set Up Terraform
Install AWS CLI If AWS CLI is not already installed on your EC2 workspace, install it using the following commands:
sudo apt update -y
sudo apt install aws-cli -y
Configured AWS CLI Ran the following command to configure AWS CLI with your AWS credentials:
aws configure
it will ask for: AWS Access Key ID: Obtained this from AWS IAM account.(security creds) AWS Secret Access Key: Obtained this from AWS IAM account.(security creds) Default region: Entered your preferred region. Default output format: Entered json.
Once the aws configure was done Created main.tf: Placed the provided Terraform configuration file in the terraform folder. /home/ubuntu/Travelmemory ├── terraform with the details specified for my ec2:
AWS region Availability zone Public IP for security group. Key pair name AMI ID
Once the main.tf file was prepared Alt text Initialized the Terraform using:

terraform init
Validated the configuration:

terraform validate
Plan and apply the configuration:

terraform plan
terraform apply
After Terraform applies, it will display: The public IP of the web server. The private IP of the backend server. Alt text

Steps to Configure and Deploy Set Up Ansible
Installed Ansible on EC2 workspace:
Created an inventory file inventory.ini in the /Travelmemory/ansible/ directory: Run Ansible Playbooks

Navigated to the /Travelmemroy/ansible/ directory:

cd ansible
Configured the backend server:

ansible-playbook -i inventory.ini backend_setup.yml
Configure the web server:

ansible-playbook -i inventory.ini web_setup.yml
Alt text
