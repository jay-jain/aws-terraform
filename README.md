# Terraform with AWS Examples

## Pre-requisites

### An AWS Account

You will need to sign up for an AWS account. These examples are meant for Free Tier (the 12-month free trial in AWS). You will need to go in the IAM console and create a user account and download the credentials. From these credentials, you will need the Access Key ID and Secret Access Key in the next step.

### AWS CLI
Download the CLI from here: https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-windows.html <br/>
Go into PowerShell (Run Elevated) <br/>
Run the following command: ```aws-configure```<br/>
Enter in your Access Key ID and Secret Access Key.<br/>
Enter your region: ```us-east-1```<br/>
Enter your output format: ```json```<br/>

### Git-SCM
Install Git-SCM: https://git-scm.com/download/win<br/>
You will now need to generate a ssh keypair with the following command in Git Bash: ```ssh-keygen -t rsa```<br/>
You should name the keypair ```terraform```. It should save in the ```.ssh``` directory in your home folder.<br/>
**Make sure that you modify the path of the location for your ssh public and private keys in your terraform scripts. <br/>**

### Terraform 
To download terraform: https://www.terraform.io/downloads.html<br/>
Follow the install instructions here (Manual Install): https://learn.hashicorp.com/terraform/getting-started/install.html<br/>
Make sure you set the path for your terraform.exe file. Here are some instructions: https://stackoverflow.com/questions/1618280/where-can-i-set-path-to-make-exe-on-windows<br/>

## Running Terraform Scripts

If it is your first time running a particular terraform script, navigate to the directory to where your script is located and execute the following command in PowerShell or CMD:<br/>
```terraform init```<br/>

If you want to format your .tf file you can use the following command<br/>
```terraform fmt```<br/>

To create the terraform plan, run:<br/>
```terraform plan```<br/>

To execute the terraform plan, run:<br/>
```terraform apply```<br/>
Type ```yes``` at the prompt to confirm the launcyh of cloud resources.<br/>

**Always remember to destroy your resources, so that you do not get charged excessively through your cloud provider** <br/>
To do this, run:<br/>
```terraform destroy```<br/>
Types ```yes``` at the prompt to confirm the destroy.<br/>
