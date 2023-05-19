#!/bin/bash

sudo apt-get update -y

apt-get install -y openjdk-11-jdk

wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | apt-key add -

sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

#This is the Debian package repository of Jenkins to automate installation and upgrade. To use this #repository, first add the key to your system
curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee     /usr/share/keyrings/jenkins-keyring.asc > /dev/null

#Then add a Jenkins apt repository entry:
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]     https://pkg.jenkins.io/debian binary/ | sudo tee     /etc/apt/sources.list.d/jenkins.list > /dev/null


#Update your local package index, then finally install Jenkins:
sudo apt-get update -y
sudo apt-get install -y jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins
sudo systemctl status jenkins
