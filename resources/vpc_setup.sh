#!/bin/bash

REGION="us-east-1"

# Step 1: Create VPC
VPC_ID=$(aws ec2 create-vpc --cidr-block 10.0.0.0/16 --region $REGION --query 'Vpc.VpcId' --output text)
echo "Created VPC: vpc-043cbdd4xxxxxxxx"

# Enable DNS hostnames
aws ec2 modify-vpc-attribute --vpc-id vpc-043cbddxxxxxxx --enable-dns-hostnames '{"Value":true}' --region $REGION
aws ec2 modify-vpc-attribute --vpc-id vpc-043cbdxxxxxxx --enable-dns-support '{"Value":true}' --region $REGION

# Step 2: Create Internet Gateway
IGW_ID=$(aws ec2 create-internet-gateway --region $REGION --query 'InternetGateway.InternetGatewayId' --output text)
echo "Created Internet Gateway: igw-0dc29xxxxxxx"
aws ec2 attach-internet-gateway --vpc-id vpc-043cbxxxxxx --internet-gateway-id igw-0dc29xxxxxxx --region $REGION

# Step 3: Create Subnets
PUBLIC_SUBNET_ID=$(aws ec2 create-subnet --vpc-id vpc-043cbdd4xxxxxx --cidr-block 10.0.1.0/24 --availability-zone ${REGION}a --region $REGION --query 'Subnet.SubnetId' --output text)
PRIVATE_SUBNET_ID=$(aws ec2 create-subnet --vpc-id vpc-043cbdxxxxx --cidr-block 10.0.2.0/24 --availability-zone ${REGION}a --region $REGION --query 'Subnet.SubnetId' --output text)
echo "Created Public Subnet: subnet-0293cddxxxxxxx"
echo "Created Private Subnet: subnet-0daccxxxxxxx"

# Step 4: Create Route Tables
PUBLIC_RT_ID=$(aws ec2 create-route-table --vpc-id vpc-043cbdxxxxxxx --region $REGION --query 'RouteTable.RouteTableId' --output text)
aws ec2 create-route --route-table-id rtb-00c26fxxxxxxx --destination-cidr-block 0.0.0.0/0 --gateway-id igw-0dc2xxxxxxx --region $REGION
aws ec2 associate-route-table --subnet-id subnet-0293cddxxxxxx --route-table-id rtb-00c26f8xxxxxxx --region $REGION
echo "Created Public Route Table: rtb-00c26f8xxxxxxx"

PRIVATE_RT_ID=$(aws ec2 create-route-table --vpc-id vpc-043cbddxxxxxxxxx --region $REGION --query 'RouteTable.RouteTableId' --output text)
aws ec2 associate-route-table --subnet-id subnet-0dacc2dxxxxxxx --route-table-id rtb-02d5e48xxxxxxx --region $REGION
echo "Created Private Route Table: rtb-02d5e48axxxxxx"

# Output Results
echo "VPC ID: vpc-043cbddxxxxxxx"
echo "Public Subnet ID: subnet-0293cdd1cxxxxxx"
echo "Private Subnet ID: subnet-0dacc2da89xxxxxxx"
echo "Internet Gateway ID: igw-0dc296b8729xxxxxx"
