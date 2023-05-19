
#!/bin/bash
sudo yum update -y
sudo yum install wget tree git -y
sudo yum install docker -y
sudo usermod -a -G docker ec2-user
sudo chkconfig docker on
sudo systemctl enable docker.service
sudo systemctl start docker.service
sudo systemctl status docker.service
