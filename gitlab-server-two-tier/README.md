
  

# GitLab Server
1. [Architectures](#arch)
2. [Installation](#installation)
3. [Configuration](#config)
4. [Miscellaneous](#misc)
5. [To Do](#todo)

## GitLab Server Architectures <a name="arch"></a>

There are two proposed architectures:

* The first involves putting the GitLab EC2 instance in a public subnet and restricting access to known IP addresses using a security group. This **one-tier** method is less secure, but is much easier to configure. Restricting access my source IP compensates for putting the EC2 instance in a public subnet.

* The second involves putting the GitLab EC2 instance in a private subnet connected to a load balancer which is in a public subnet. This **two-tier** method is more secure, but requires much more configuration. In particular, the nginx reverse proxy on the EC2 instance must be configured properly to pass the traffic from the load balancer to port 5050 on the EC2 instance for the container registry to work.

### One-Tier Architecture

![One-Tier](/images/one-tier.png)

### Two-Tier Architecture

![Two-Tier](/images/two-tier.png)

## Installation <a name="installation"></a>

Make sure to fill in the subdomain and domain you which to use on the fourth command.

```

sudo apt-get update

sudo apt-get install -y curl openssh-server ca-certificates

curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash

sudo EXTERNAL_URL="https://<SUBDOMAIN>.<DOMAIN>" apt-get install gitlab-ee

sudo apt-get install -y postfix

```

## Configuration <a name="config"></a>

Although, there is a provided [bootstrap.sh](https://github.com/jay-jain/aws-terraform/blob/master/gitlab-server-two-tier/bootstrap.sh) script which you can pass into user data, it is not recommended to use this. It is best to manually setup the server first, test the server, and then make an AMI of the server configuration. The reason for this is that if you install the GitLab server on an EC2 instance multiple times, LetsEncrypt will start to fail after a couple of times because there is a limit of how many times you can generate a certificate. Therefore, using an AMI image is better since it is not creating a new certificate each time. Additionally, LetsEncrypt automatic certificate renewal is turned on by default, so you don't have to worry about manually renewing the certificate as time passes.

All configuration is handled in the ```/etc/gitlab/gitlab.rb``` file.

### Server URL

Make sure to use *https* here. Encryption is enabled by default. The gitlab installation package. This line will be filled in automatically if you use the above installation commands.

```external_url 'https://<SUBDOMAIN>.<DOMAIN>'```

### Registry URL

```registry_external_url 'https://<SUBDOMAIN>.<DOMAIN>:5050'```

Note, this method uses port 5050 to access the container registry, but you can also use a different subdomain. See the [documentation](https://docs.gitlab.com/ee/administration/packages/container_registry.html#container-registry-domain-configuration) for more information.

### Registry Object Storage

Instead of storing the container repositories on your EC2 instance, storing them on a S3 bucket is a much scalable and reliable method. You will need to make the following modifications to the ```gitlab.rb``` file:

```

registry['storage'] = {
	's3' => {
		'bucket' => '<BUCKET_NAME>',
		'region' => 'us-east-1',
	},
	'redirect' => {
		'disable' => false
	}
}

```

Note, you can disable proxy download by setting: ```'disable' => true ```

This will improve security as it will force traffic to go through the Gitlab Registry Service, but it will decrease performance as the server will have to deal with more requests. [Read more here.](https://docs.gitlab.com/ee/administration/packages/container_registry.html#disable-redirect-for-storage-driver)

Note, you will also have to use the IAM instance profile for S3 which is [provided in the Terraform code](https://github.com/jay-jain/aws-terraform/blob/master/gitlab-server/instance_profile.tf) in order for the GitLab server to access S3.

### Object Storage

In addition to storing registry data in S3, you can store other data such as uploads, packages, artifacts, etc. For this to work, you will need S3 buckets with public-read-write access. Here is a [terraform script](https://github.com/jay-jain/aws-terraform/blob/master/gitlab-object-storage/s3-gitlab-storage.tf) that does that creates them for you. Note, you will have to change the bucket names to globally unique S3 bucket names.

Additionally, you will have to provide the bucket names for each object storage service and some additional configuration in the ```gitlab.rb``` file as seen below:

```

gitlab_rails['object_store_connection'] = {
	'provider' => 'AWS',
	'region' => 'us-east-1',
	'use_iam_profile' => true
}

gitlab_rails['object_store']['enabled'] = true

gitlab_rails['object_store']['storage_options'] = {
	'provider' => 'AWS',
	'region' => 'us-east-1'
}

gitlab_rails['object_store']['proxy_download'] = true

gitlab_rails['object_store']['objects']['artifacts']['bucket'] = '<BUCKET_NAME>'

gitlab_rails['object_store']['objects']['external_diffs']['bucket'] = '<BUCKET_NAME>'

gitlab_rails['object_store']['objects']['lfs']['bucket'] = '<BUCKET_NAME>'

gitlab_rails['object_store']['objects']['uploads']['bucket'] = '<BUCKET_NAME>'

gitlab_rails['object_store']['objects']['packages']['bucket'] = '<BUCKET_NAME>'

gitlab_rails['object_store']['objects']['dependency_proxy']['bucket'] = '<BUCKET_NAME>'

gitlab_rails['object_store']['objects']['terraform_state']['bucket'] = '<BUCKET_NAME>'

```

### Reconfigure

After you have made all the necessary edits to the ```gitlab.rb``` file you will need to run the following command for the changes to take place:

```sudo gitlab-ctl reconfigure```

The instance will go down for a little while, but after a couple of minutes it should be accessible again via the web.

### Make an AMI

In the EC2 Console, you can select the instance and make an image. This can take a while (around 10-15 minutes). This will also cause your EC2 instance to become unresponsive for that time period.

In your Terraform code, you can then get the AMI ID and use it in your launch configuration, so that you can have a fully configured AMI ready to go for your auto-scaling group.

To set the AMI id, you can to the [variables.tf](https://github.com/jay-jain/aws-terraform/blob/master/gitlab-server/variables.tf) file and replace it there.

## Miscellaneous <a name="misc"></a>

### SSH into GitLab EC2 Instance

To SSH into the GitLab server easily, you must assign the same private key to both the bastion host and the GitLab instance.

Then add the private key (in .pem format) to your ssh keychain with:

  

```ssh-add -k myPrivateKey.pem```

  

To see which keys have been added to your keychain:

  

``` ssh-add -L ```

  

Now when you do not have to specify your keypair everytime you SSH.

  

You can SSH into your bastion host with :

  

``` ssh -A ubuntu@<bastion-IP-address or DNS-entry> ```

  

Then you can SSH into your private instance the same way.

  

### Disable LetsEncrypt on install

```

sudo GITLAB_OMNIBUS_CONFIG="letsencrypt['enable'] = false" EXTERNAL_URL="https://<SUBDOMAIN>.<DOMAIN>" apt-get install gitlab-ee

```

### Bootstrap Script - Install Postfix

If you want to boostrap install postfix, you will need some extra code to handle the configuration screen that comes up:

```

sudo apt install -y debconf-utils

  

echo "postfix postfix/main_mailer_type select Internet Site" | debconf-set-selections

  

echo "postfix postfix/mailname string gitlab.sci-tings.org" | debconf-set-selections

  

sudo apt-get install -y postfix

```

  

### Bootstrap Script - Replace Lines in Configuration File

Replaces External URL line in ```gitlab.rb``` file:

```sudo sed -i "32s/.*/external_url 'https:\/\/<SUBDOMAIN>.<DOMAIN>'/"/etc/gitlab/gitlab.rb```

### Renew LetsEncrypt Certificates Manually

``` sudo gitlab-ctl renew-le-certs ```
  

### Configuration for Container Registry (NGINX) behind ELB

* https://forum.gitlab.com/t/insecure-registry/30643/3

  
  

## TODO <a name="todo"></a>

* Implement [asg-dns-handler] (https://github.com/meltwater/terraform-aws-asg-dns-handler) for One-Tier Architecture

* Implement RDS - Postgres Integration

* Integrate EBS mounting and dismounting with bootstrap script
	* https://github.com/fpco/terraform-aws-foundation/blob/v0.9.16/examples/gitlab-ha/main.tf

* Implement SSH Key Rotation with Secrets Manager

