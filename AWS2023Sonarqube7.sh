#!/bin/bash
sudo yum update -y
sudo yum install wget tree git -y
cd /opt
sudo yum install java-11-amazon-corretto -y
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-7.8.zip
sudo unzip sonarqube-7.8.zip
sudo useradd sonar

echo 'sonar ALL=(ALL) NOPASSWD:ALL' | EDITOR='tee -a'  visudo

sudo chown -R sonar:sonar /opt/sonarqube-7.8/
sudo chmod 755 /opt/sonarqube-7.8
sudo ln -s /opt/sonarqube-7.8 /opt/sonarqube

echo '''vm.max_map_count=524288
fs.file-max=131072
ulimit -n 131072
ulimit -u 8192''' >> /etc/sysctl.conf

echo '''
sonarqube   -   nofile   131072
sonarqube   -   nproc    8192''' >> /etc/security/limit.conf

echo '''[Unit]
Description=SonarQube service
After=syslog.target network.target
​
[Service]
Type=forking
User=sonar
Group=sonar
PermissionsStartOnly=true
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start 
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
StandardOutput=syslog
LimitNOFILE=65536
LimitNPROC=4096
TimeoutStartSec=5
Restart=always
​
[Install]
WantedBy=multi-user.target''' > /etc/systemd/system/sonarqube.service

systemctl daemon-reload
systemctl start sonarqube.service
systemctl enable sonarqube.service
systemctl status sonarqube.service
