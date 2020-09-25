
  

# Terraform Backend - S3/DynamoDB

### References :

* See: __https://github.com/cloudposse/terraform-aws-tfstate-backend__
* Read more about S3 Backend [here](https://www.terraform.io/docs/backends/types/s3.html)
* Use Terraform to provision backend in one project and use separate projects to provision other resources [Link](https://stackoverflow.com/questions/61851903/how-to-solve-error-loading-state-accessdenied-access-denied-status-code-403-w)
  

# Create Backend

## Configure the `main.tf` file

```

module "terraform_state_backend" {
	source = "git::https://github.com/cloudposse/terraform-aws-tfstate-backend.git?ref=tags/0.26.0"
	namespace = "DevSecOpsGroup"
	stage = "dev"
	name = var.name_prefix
	attributes = ["state"]
	region = "us-east-1"
 	
	terraform_backend_config_file_path = "."
	terraform_backend_config_file_name = "backend.tf"
	force_destroy = false
}

```

## Download Terraform modules and providers

  

`terraform init`

  

## Create S3 Bucket and DynamoDB Lock Table (state is still stored locally)

`terraform apply -auto-approve`

  

The following resources are created when the above command is run:

* S3 Bucket

* [S3 Public Access Block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block)

* DynamoDB Table

* A file called `backend.tf` that stores the backend configuration. It should look something like this:

```

backend "s3" {
	region = "us-east-1"
	bucket = "< the name of the S3 state bucket >"
	key = "terraform.tfstate"
	dynamodb_table = "< the name of the DynamoDB locking table >"
	profile = ""
	role_arn = ""
	encrypt = true
}

```

* Additionally the `bucket_id` and `lock_table_id` parameters are output.

  

Note: If you want to use the S3 Remote Backend, you will need to use the `backend.tf` file generated here in other terraform project folders; otherwise the backend will be stored locally by default.

## Copy state from local backend to S3/DynamoDB backend

  
**Make sure that you have copied the `backend.tf` to your working directory where you are running this init command:**
 
`terraform init -force-copy`

  

**Do not run the above command in the `tfbackend` directory. Run it in the directory where you are deploying actual resources.**

# Deleting Remote Backend

## Change tfbackend.tf to:

  

```

module "terraform_state_backend" {
	...
	terraform_backend_config_file_path = ""
	force_destroy = true
}

```

  

## Deletes backend.tf

  

`terraform apply -target module.terraform_state_backend -auto-approve`

  

  

## Move Terraform state from S3 backend to local files

  

`terraform init -force-copy`

  

## Delete all resources in deployment

  

`terraform destroy`

  

  

## Examine the `terraform.tfstate` file to make sure it contains no resources to verify state has been deleted
