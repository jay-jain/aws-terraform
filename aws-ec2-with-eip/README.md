
# Launching EC2 instance with Elastic IP
## What is an Elastic IP (EIP)?
* An elastic IP is just a static IP that you can give to the EC2 instance that you launch. Under AWS Free Tier, as long as the EIP is attached to a running EC2 instance, you will __not__ be charged extra.
	* Remember, if you have an elastic IP that is not being used, you must go and release that elastic IP so you don't get charged extra.
	* You can do that in the EC2 Managment console. Luckily, with this script, when you run ```terraform destroy```, that elastic IP is automatically released along with the EC2 instance.<br  />
	* Note, that if you do not have to assign an Elastic IP to the EC2 instance; it will assign a temporary static IP to that instance at launch time.
***
__So, you might be wondering:__
**What is the difference between an Elatic IP (EIP) and a Temporary Static IP in AWS?**
* An Elastic IP persists after an EC2 instance is deleted. This means that you will still have access to this IP address even after your instance is deleted. This is why you will be charged if you do not go in and manually release this elastic IP. 
* With the temporary static IP, you are assigned this static IP when the instance is launched and it is lost when the instance is terminated. 
## What does this script do?

**1)** Launches an EC2 instance of type t2.micro with the Amazon Linux 2 AMI

**2)** Places the instance in the default VPC

**3)** Specifically, a Security Group within the VPC is created that allows for SSH Access (Port 22) and HTTP Access (Port 80)

**4)** Installs and configures an nginx server

Note: As you will see in the script, you must fill in the name of the key where it says: ```key_name  =  "YOUR_KEY_NAME"```.


**5)** Attaches an Elastic IP to the server so that you can view a webpage that is hosted on the server.

**6)**. Writes the Elastic IP address to a text file. After you successfully run the ```terraform apply``` command  you can copy and paste that elastic IP from the text file into your web browser, where you will then be able to access a web page hosted on that web browser. 

## Optional

Create a file called `terraform.tfvars` and define the `ssh_priv_key_path` and `ssh_pub_key_path` variables:

```
ssh_priv_key_path = "path/to/your/priv_key"

ssh_pub_key_path = "path/to/your/pub_key.pub"
```
