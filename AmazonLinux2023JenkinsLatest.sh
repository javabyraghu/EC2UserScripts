#!/bin/bash
sudo yum update -y
sudo yum install wget tree git -y
sudo yum install java-11-amazon-corretto -y
#sudo amazon-linux-extras install java-openjdk11
#sudo yum install java-1.8.0-openjdk
sudo rm -rf /opt/maven*
sudo wget https://dlcdn.apache.org/maven/maven-3/3.8.8/binaries/apache-maven-3.8.8-bin.tar.gz -P /tmp
sudo tar xvzf /tmp/apache-maven-3.*-bin.tar.gz -C /opt
sudo ln -s /opt/apache-maven-3.* /opt/maven
sudo touch  /etc/profile.d/maven.sh


echo '''# Apache Maven Environmental Variables
# MAVEN_HOME for Maven 1 - M2_HOME for Maven 2
export JAVA_HOME=/usr/lib/jvm/java-11-amazon-corretto.x86_64/
export M2_HOME=/opt/maven/
export MAVEN_HOME=/opt/maven/
export PATH=${M2_HOME}/bin:${PATH}:${JAVA_HOME}''' | sudo tee /etc/profile.d/maven.sh > /dev/null
sudo chmod 775 /etc/profile.d/maven.sh
source /etc/profile.d/maven.sh
mvn -version

sudo yum update -y
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
	
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins
