# AWS Grocery Project

This repository contains the code for the infrastructure deployed with AWS for the Grocery Project.

# Infrastructure Overview

The infrastructure is organized into three main modules: Compute, Database, and Networking.

### Defined Services List

#### Compute Module
- **ALB** - Application Load Balancer
- **ASG** - Auto Scaling Groups
- **EC2** - Elastic Compute Cloud
- **AWS Security Groups** - Controls inbound and outbound traffic

#### Database Module
- **RDS** - Relational Database Service
- **AWS Security Groups** - Controls access to the database

#### Networking Module
- **VPC** - Virtual Private Cloud
- **IGW** - Internet Gateway
- **NAT Gateways** - Enables outbound internet access for instances in a private subnet
- **EIP** - Elastic IP addresses for static public IPs
- **Subnets** - Segregate resources within the VPC
- **Route Tables** - Controls the routing of traffic within the VPC
