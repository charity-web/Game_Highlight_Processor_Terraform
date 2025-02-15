#!/bin/bash

REGION="us-east-1"

# Step 1: Create VPC
VPC_ID=$(aws ec2 create-vpc --cidr-block 10.0.0.0/16 --region $REGION --query 'Vpc.VpcId' --output text)
echo "Created VPC: vpc-043cbdd4550d22ab3"

# Enable DNS hostnames
aws ec2 modify-vpc-attribute --vpc-id vpc-043cbdd4550d22ab3 --enable-dns-hostnames '{"Value":true}' --region $REGION
aws ec2 modify-vpc-attribute --vpc-id vpc-043cbdd4550d22ab3 --enable-dns-support '{"Value":true}' --region $REGION

# Step 2: Create Internet Gateway
IGW_ID=$(aws ec2 create-internet-gateway --region $REGION --query 'InternetGateway.InternetGatewayId' --output text)
echo "Created Internet Gateway: igw-0dc296b8729b72bdc"
aws ec2 attach-internet-gateway --vpc-id vpc-043cbdd4550d22ab3 --internet-gateway-id igw-0dc296b8729b72bdc --region $REGION

# Step 3: Create Subnets
PUBLIC_SUBNET_ID=$(aws ec2 create-subnet --vpc-id vpc-043cbdd4550d22ab3 --cidr-block 10.0.1.0/24 --availability-zone ${REGION}a --region $REGION --query 'Subnet.SubnetId' --output text)
PRIVATE_SUBNET_ID=$(aws ec2 create-subnet --vpc-id vpc-043cbdd4550d22ab3 --cidr-block 10.0.2.0/24 --availability-zone ${REGION}a --region $REGION --query 'Subnet.SubnetId' --output text)
echo "Created Public Subnet: subnet-0293cdd1c5afef705"
echo "Created Private Subnet: subnet-0dacc2da89d05a9e1"

# Step 4: Create Route Tables
PUBLIC_RT_ID=$(aws ec2 create-route-table --vpc-id vpc-043cbdd4550d22ab3 --region $REGION --query 'RouteTable.RouteTableId' --output text)
aws ec2 create-route --route-table-id rtb-00c26f8b744e8e82f --destination-cidr-block 0.0.0.0/0 --gateway-id igw-0dc296b8729b72bdc --region $REGION
aws ec2 associate-route-table --subnet-id subnet-0293cdd1c5afef705 --route-table-id rtb-00c26f8b744e8e82f --region $REGION
echo "Created Public Route Table: rtb-00c26f8b744e8e82f"

PRIVATE_RT_ID=$(aws ec2 create-route-table --vpc-id vpc-043cbdd4550d22ab3 --region $REGION --query 'RouteTable.RouteTableId' --output text)
aws ec2 associate-route-table --subnet-id subnet-0dacc2da89d05a9e1 --route-table-id rtb-02d5e48ab86be712f --region $REGION
echo "Created Private Route Table: rtb-02d5e48ab86be712f"

# Output Results
echo "VPC ID: vpc-043cbdd4550d22ab3"
echo "Public Subnet ID: subnet-0293cdd1c5afef705"
echo "Private Subnet ID: subnet-0dacc2da89d05a9e1"
echo "Internet Gateway ID: igw-0dc296b8729b72bdc"