#! /bin/bash

echo $(date) >> ~/date.txt

sudo apt-get update
sudo apt-get install -y curl openssh-server ca-certificates

curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash

## Change external URL 
#sudo GITLAB_OMNIBUS_CONFIG="letsencrypt['enable'] = false" EXTERNAL_URL="https://gitlab.sci-tings.org" apt-get install gitlab-ee
sudo EXTERNAL_URL="http://gitlab.sci-tings.org" apt-get install gitlab-ee
#sudo gitlab-ctl renew-le-certs

sudo apt install -y debconf-utils
echo "postfix postfix/main_mailer_type select Internet Site" | debconf-set-selections
echo "postfix postfix/mailname string gitlab.sci-tings.org" | debconf-set-selections
sudo apt-get install -y postfix

sudo sed -i "2007s/.*/letsencrypt['enable'] = false/" /etc/gitlab/gitlab.rb

# Reconfigure to use HTTPS
sudo sed -i "32s/.*/external_url 'https:\/\/gitlab.sci-tings.org'/" /etc/gitlab/gitlab.rb
sudo gitlab-ctl reconfigure

echo $(date) >> ~/date.txt