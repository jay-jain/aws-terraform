
# Launching EC2 instance without an EIP

* This script launches an EC2 instance without and elastic IP. It uses just the default, temporary static IP assigned to it at launch. 
* The static IP is written to a file called ```ip_address.txt``` which you can visit in your browser to test that the nginx server works.

* To run this script, read the README at the top-level of this repository

* **Make sure you run ``` terraform destroy ``` after you are done with this example.**

  
## Optional

Create a file called `terraform.tfvars` and define the `ssh_priv_key_path` and `ssh_pub_key_path variables`:

```
ssh_priv_key_path = "path/to/your/priv_key"

ssh_pub_key_path = "path/to/your/pub_key.pub"
```
