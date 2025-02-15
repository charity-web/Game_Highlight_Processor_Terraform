Part 2 - Terraform Bonus

This project builds on our previous NCAA game highlight processing pipeline: https://github.com/charity-web/NCAAGameHighlights.git, which used a deployment script. We're now implementing a full end-to-end deployment using Terraform. This Infrastructure-as-Code approach allows us to manage AWS resources consistently and scalably, automating video ingestion, processing, and delivery.

PREREQUISITES:

Prerequisites Before we get started, ensure you have the following:

RapidAPI Account: Sign up for a RapidAPI account and subscribe to an API that provides NCAA game highlights.
AWS Account: AWS access with the required permission to access the necessary services.
Docker Installed: Install Docker on your system to run the containerized workflow.
Terraform Installed: Ensure Terraform is installed for infrastructure deployment.
Basic CLI Knowledge: Familiarity with using command-line tools for API requests, AWS configurations, and Terraform commands.
Tech Stack

Python
AWS ECR, ECS & Elemental MediaConvert
Docker
Terraform

TECHNICAL DIAGRAM
![image](https://github.com/user-attachments/assets/33ae1dae-93c0-43a5-a3b9-c2345aefc951)


STEPS

Setup terraform.tfvars File
In the github repo, there is a resources folder and copy the entire contents
In the AWS Cloudshell or vs code terminal, create the file vpc_setup.sh and paste the script inside.
Run the script
bash vpc_setup.sh
You will see variables in the output, paste these variables into lines 8-13.
Store your API key in AWS Secrets Manager
aws ssm put-parameter \
  --name "/myproject/rapidapi_key" \
  --value "YOUR_SECRET_KEY" \
  --type SecureString
Run the following script to obtain your mediaconvert_endpoint:
aws mediaconvert describe-endpoints --query "Endpoints[0].Url" --output text
Leave the mediaconvert_role_arn string empty
Helpful Tip for Beginners:

Use the same region, project, S3 Bucketname and ECR Repo name to make following along easier. Certain steps like pushing the docker image to the ECR repo is easier to copy and paste without remember what you named your repo :)
Run The Project
Navigate to the terraform folder/workspace in VS Code From the src folder
cd terraform
Initialize terraform working directory
terraform init
Check syntax and validity of your Terraform configuration files
terraform validate
Display execution plan for the terraform configuration
terraform plan
Apply changes to the desired state
terraform apply -var-file="terraform.dev.tfvars"
Create an ECR Repo
aws ecr create-repository --repository-name highlight-pipeline
Log into ECR
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com
Build and Push the Docker Image
docker build -t highlight-pipeline:latest .
docker tag highlight-pipeline:latest <AWS_ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/highlight-pipeline:latest
docker push <AWS_ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/highlight-pipeline:latest
Destroy ECS and ECR resources
In the AWS Cloudshell or vs code terminal, create the file ncaaprojectcleanup.sh and paste the script inside from the resources folder.
Run the script
bash ncaaprojectcleanup.sh
Review Video Files
Navigate to the S3 Bucket and confirm there is a json video in the highlights folder and a video in the videos folder

What We Learned
Deploying local docker images to ECR
A high level overview of terraform files
Networking - VPCs, Internet Gateways, private subnets and public subnets
SSM for saving secrets and pulling into terraform

Future Enhancements
Automating the creation of VPCs/networking infra, media endpoint
