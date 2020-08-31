# GitLab Server

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