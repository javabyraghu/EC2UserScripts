#!/bin/bash
sudo yum update -y
sudo yum install wget -y
sudo yum install java-1.8.0-amazon-corretto -y
sudo wget https://download.sonatype.com/nexus/3/nexus-3.53.0-01-unix.tar.gz -P /tmp
sudo tar xvzf /tmp/nexus-3.53.0-01-unix.tar.gz -C /opt/
sudo mv /opt/nexus-3.53.0-01/ /opt/nexus
sudo useradd nexus

echo 'nexus ALL=(ALL) NOPASSWD:ALL' > sudo visudo

sudo chown -R nexus:nexus /opt/nexus
sudo chown -R nexus:nexus /opt/sonatype-work
sudo chmod -R 775 /opt/nexus
sudo chmod -R 775 /opt/sonatype-work

echo 'run_as_user="nexus"' | sudo tee /opt/nexus/bin/nexus.rc

sudo touch /etc/systemd/system/nexus.service
echo '''[Unit]
Description=nexus service
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
User=nexus
Group=nexus
ExecStart=/opt/nexus/bin/nexus start
ExecStop=/opt/nexus/bin/nexus stop
User=nexus
Restart=on-abort

[Install]
WantedBy=multi-user.target
''' | sudo tee /etc/systemd/system/nexus.service

sudo systemctl enable nexus
sudo systemctl start nexus
sudo systemctl status nexus
sudo cat /opt/nexus/etc/nexus-default.properties
