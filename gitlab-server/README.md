
# GitLab Server

## GitLab Server Architectures
There are two proposed architectures:
* The first involves putting the GitLab EC2 instance in a public subnet and restricting access to known IP addresses using a security group. This one-tier method is less secure, but is much easier to configure. Restricting access my source IP compensates for putting the EC2 instance in a public subnet.
* The second involves putting the GitLab EC2 instance in a private subnet connected to a load balancer which is in a public subnet. This two-tier method is more secure, but requires much more configuration. 

### Two-Tier Architecture
![Two-Tier](/images/two-tier.png)

## SSH into GitLab EC2 Instance
To SSH into the GitLab server easily, you must assign the same private key to both

the bastion host and the GitLab instance.

Then add the private key (in .pem format) to your ssh keychain with:

```ssh-add -k myPrivateKey.pem```

To see which keys have been added to your keychain:

``` ssh-add -L ``` 

Now when you do not have to specify your keypair everytime you SSH.

You can SSH into your bastion host with :

``` ssh -A ubuntu@<bastion-IP-address or DNS-entry> ```

Then you can SSH into your private instance the same way.
