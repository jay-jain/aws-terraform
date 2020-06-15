# Launching EC2 instance without an EIP
This script launches an EC2 instance without and elastic IP. It uses just the default, temporary static IP assigned to it at launch. <br>
The static IP is written to a file called ```ip_address.txt``` which you can visit in your browser to test that the nginx server works.<br>
To run this script, read the README in the index of this repository.
**Make sure you run ``` terraform destroy ``` after you are done with this example.**
