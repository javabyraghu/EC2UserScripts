#!/bin/bash
sudo yum update -y
sudo yum install wget tree git -y
sudo yum install java-11-amazon-corretto -y
#sudo useradd -m -U -d /opt/tomcat tomcat

cd /tmp
wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.75/bin/apache-tomcat-9.0.75.tar.gz
sudo tar xzvf apache-tomcat-9*tar.gz -C /opt
sudo mv /opt/apache-tomcat-9.0.75 /opt/tomcat
sudo chown -R ec2-user:ec2-user /opt/tomcat

sudo find /opt/tomcat/bin -name "*.sh" -exec sudo chmod 775 {} \;

sudo touch /etc/systemd/system/tomcat.service

echo '''[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=oneshot
RemainAfterExit=yes

User=ec2-user
Group=ec2-user

Environment="/usr/lib/jvm/java-11-amazon-corretto.x86_64/"
Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom -Djava.awt.headless=true"
Environment="CATALINA_BASE=/opt/tomcat"
Environment="CATALINA_HOME=/opt/tomcat"
Environment="CATALINA_PID=/opt/tomcat/temp/tomcat.pid"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"
ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

[Install]
WantedBy=multi-user.target''' | sudo tee /etc/systemd/system/tomcat.service > /dev/null


sed -i 's/<\/tomcat-users>/<role rolename="admin-gui"\/>\
<role rolename="manager-gui"\/>\
<role rolename="manager-script"\/>\
<user username="admin" password="admin" roles="admin-gui,manager-gui"\/>\
<user username="deployer" password="deployer" roles="manager-script"\/>\
<\/tomcat-users>/' /opt/tomcat/conf/tomcat-users.xml

sed -i "s/0:0:0:0:0:0:0:1/0:0:0:0:0:0:0:1|.*/" /opt/tomcat/webapps/manager/META-INF/context.xml

sed -i "s/0:0:0:0:0:0:0:1/0:0:0:0:0:0:0:1|.*/" /opt/tomcat/webapps/host-manager/META-INF/context.xml

sudo systemctl daemon-reload
sudo systemctl enable tomcat
sudo systemctl start tomcat
