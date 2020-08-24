#! /bin/bash

sudo apt-get update
sudo apt-get install -y curl openssh-server ca-certificates

curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash

## Change external URL 
sudo EXTERNAL_URL="https://gitlab.sci-tings.org" apt-get install gitlab-ee

sudo apt install -y debconf-utils
echo "postfix postfix/main_mailer_type select Internet Site" | debconf-set-selections
echo "postfix postfix/mailname string gitlab.sci-tings.org" | debconf-set-selections
sudo apt-get install -y postfix
