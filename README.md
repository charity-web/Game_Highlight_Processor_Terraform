**Automating NCAA Game Highlights with AWS & Terraform!**

This project builds on our previous NCAA game highlight processing pipeline: https://github.com/charity-web/NCAAGameHighlights.git, which used a deployment script. We're now implementing a full end-to-end deployment using Terraform. This Infrastructure-as-Code approach allows us to manage AWS resources consistently and scalably, automating video ingestion, processing, and delivery.

**PREREQUISITES:**

**RapidAPI Account**: Sign up for a RapidAPI account and subscribe to an API that provides NCAA game highlights.

**AWS Account**: AWS access with the required permission to access the necessary services.

**Docker Installed**: Install Docker on your system to run the containerized workflow.

**Terraform Installed**: Ensure Terraform is installed for infrastructure deployment.

**Basic CLI Knowledge**: Familiarity with using command-line tools for API requests, AWS configurations, and Terraform commands.


**TECHNICAL DIAGRAM**
![image](https://github.com/user-attachments/assets/33ae1dae-93c0-43a5-a3b9-c2345aefc951)


**STEP 1**: Setup terraform.tfvars File

1. In the github repo: https://github.com/charity-web/Game_Highlight_Processor_Terraform.git, copy the entire content in teh resources folder.
2. In the AWS Cloudshell or vs code terminal, create the file **vpc_setup.sh** and paste the script inside.
3. Run the script
   ```
   bash vpc_setup.sh
   ```
4. You will see variables in the output, paste these variables into lines 8-13.
5. Store your API key in AWS Secrets Manager
  ```
  aws ssm put-parameter \
  --name "/myproject/rapidapi_key" \
  --value "YOUR_SECRET_KEY" \
  --type SecureString
  ```
6. Run the following script to obtain your mediaconvert_endpoint:
  ```
  aws mediaconvert describe-endpoints --query "Endpoints[0].Url" --output text
  ```
7. Leave the mediaconvert_role_arn string empty
   

**STEP 2:** Run The Project

1. Navigate to the terraform folder/workspace in VS Code From the src folder
```
cd terraform
```
2. Initialize terraform working directory
```
terraform init
```
3. Check syntax and validity of your Terraform configuration files
```
terraform validate
```
4. Display execution plan for the terraform configuration
```
terraform plan
```
5. Apply changes to the desired state
```
terraform apply -var-file="terraform.dev.tfvars"
```
![image 1](https://github.com/user-attachments/assets/4c9742e8-138c-435c-a69c-69fefa751134)

6. Create an ECR Repo
```
aws ecr create-repository --repository-name highlight-pipeline
```
7. Log into ECR
```
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com
```
8. Build and Push the Docker Image
```
docker build -t highlight-pipeline:latest .
docker tag highlight-pipeline:latest <AWS_ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/highlight-pipeline:latest
docker push <AWS_ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/highlight-pipeline:latest
```
![image 2](https://github.com/user-attachments/assets/64f9a09a-9347-4a9d-8f4b-00f2f7cb2190)



**STEP 3:** Destroy ECS and ECR resources

1. In the AWS Cloudshell or vs code terminal, create the file ncaaprojectcleanup.sh and paste the script inside from the resources folder.
2. Run the script
```
bash ncaaprojectcleanup.sh
```

**Review Video Files**
1. Navigate to the S3 Bucket and confirm there is a json video in the highlights folder and a video in the videos folder

![image 3](https://github.com/user-attachments/assets/60dc515a-a2bd-4d51-9130-67e3c370beef)


**What We Learned**
1. Deploying local docker images to ECR
2. A high level overview of terraform files
3. Networking - VPCs, Internet Gateways, private subnets and public subnets
4. SSM for saving secrets and pulling into terraform

**Future Enhancements**
1. Automating the creation of VPCs/networking infra, media endpoint
