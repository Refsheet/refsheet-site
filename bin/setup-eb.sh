#!/bin/bash
#
# This will set up Elastic Beanstalk command lines, it is useful that you run this thing
# on a CI server or the system you plan to use to deploy the app on.
#
# Note that you need environment variables, AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
# configured on your system first, and the IAM account behind those needs to have
# permissions to deploy a Beanstalk.

set -e

echo "Setting Git"
git config --global user.email "mau+ci@refsheet.net"
git config --global user.name "Refsheet [CI]"

echo "Installing EB packages..."

sudo apt-get install python-setuptools python-dev build-essential
sudo easy_install pip
sudo pip uninstall urllib3
sudo pip install -Iv urllib3==1.21.1
sudo pip install awsebcli
sudo easy_install --upgrade six

echo "Configuring Elastic Beanstalk for deploy:"
pwd

mkdir ~/.aws
touch ~/.aws/config
chmod 600 ~/.aws/config
echo "[profile eb-cli]" > ~/.aws/config

echo "Using: $AWS_ACCESS_KEY_ID"
echo "aws_access_key_id=$AWS_ACCESS_KEY_ID" >> ~/.aws/config
echo "aws_secret_access_key=$AWS_SECRET_ACCESS_KEY" >> ~/.aws/config
echo "region=us-east-1" >> ~/.aws/config

echo "Beanstalk configured"
