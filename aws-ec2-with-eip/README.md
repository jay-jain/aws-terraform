# Launching EC2 instance with Elastic IP
## What is an Elastic IP (EIP)?
An elastic IP is just a static IP that you can give to your EC2 instance that you launch. Under AWS Free Tier, <br/>
as long as the EIP is attached to a running EC2 instance, you will not be charged extra. 
Remember, if you have an elastic IP that is not being used, you must go and release that elastic IP so you don't get charged extra. <br />
You can do that in the EC2 Managment console. Luckily, with this script, when you run ```terraform destroy```, that elastic IP is <br />
automatically released along with the EC2 instance.<br />
Note, that if you do not assign an Elastic IP to the EC2 instance, it will assign a temporary static IP to that instance.<br />

So, you might be wondering: <br />
**What is the difference between an Elatic IP (EIP) and a Temporary Static IP in AWS?**<br />
An Elastic IP persists after an EC2 instance is deleted. This means that you will still have access to this IP address even after<br/>
your instance is deleted. This is why you will be charged if you do not go in and manually release this elastic IP. <br />
With the temporary static IP, you are assigned this static IP when the instance is launched and it is lost when the instance is <br />
terminated.

## What does this script do?
1) Launches an EC2 instance of type t2.micro with the Amazon Linux 2 AMI
2) Places the instance in the default VPC
3) Specifically, a Security Group within the VPC is created that allows for SSH Access (Port 22) and HTTP Access (Port 80)
4) Downloads and uses an SSH Key that is used to autonomously connect to the server and  then install and configures an nginx server
5) Attaches an Elastic IP to the server so that you can view a webpage that is hosted on the server.
6). Writes the Elastic IP address to a text file. After you successfully run the ```terraform apply``` command <br />
you can copy and paste that elastic IP from the text file into your web browser, where you will then be able to access a web page <br />
hosted on that web browser.
