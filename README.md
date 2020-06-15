# Terraform with AWS Examples

## Pre-requisites

### An AWS Account

You will need to sign up for an AWS account. These examples are meant for Free Tier (the 12-month free trial in AWS). You will need to go in the IAM console and create a user account and download the credentials. From these credentials, you will need the Access Key ID and Secret Access Key in the next step.

### AWS CLI
Download the CLI from here: https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-windows.html 
Go into PowerShell (Run Elevated) 
Run the following command: ```aws-configure```
Enter in your Access Key ID and Secret Access Key.
Enter your region: ```us-east-1```
Enter your output format: ```json```

### Git-SCM
Install Git-SCM: https://git-scm.com/download/win
You will now need to generate a ssh keypair with the following command in Git Bash: ```ssh-keygen -t rsa```
You should name the keypair ```terraform```. It should save in the ```.ssh``` directory in your home folder.
Make sure that you modify the path of your ssh public and private keys in your terraform scripts. 

### Terraform 
To download terraform: https://www.terraform.io/downloads.html
Follow the install instructions here (Manual Install): https://learn.hashicorp.com/terraform/getting-started/install.html
Make sure you set the path for your terraform.exe file. Here are some instructions: https://stackoverflow.com/questions/1618280/where-can-i-set-path-to-make-exe-on-windows

## Running Terraform Script

If it is your first time running a particular terraform script, navigate to the directory to where your script is located and execute the following command in PowerShell or CMD:
```terraform init```

If you want to format your .tf file you can use the following command
```terraform fmt```

To create the terraform plan, run:
```terraform plan```
Type ```yes``` at the prompt to confirm the plan.

To execute the terraform plan, run:
```terraform apply```
Type ```yes``` at the prompt to confirm the launcyh of cloud resources.

** Always remember to destroy your resources, so that you do not get charged excessively through your cloud provider**
To do this, run:
```terraform destroy```
Types ```yes``` at the prompt to confirm the destroy.
