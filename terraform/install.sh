#!/bin/bash
set -e

# Update and install prerequisite packages
sudo apt-get update -y
sudo apt-get install -y wget curl gnupg lsb-release apt-transport-https ca-certificates software-properties-common

# 1. Install Java (Eclipse Temurin JDK 17)
sudo mkdir -p /etc/apt/keyrings
wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | sudo tee /etc/apt/keyrings/adoptium.asc
echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | sudo tee /etc/apt/sources.list.d/adoptium.list
sudo apt-get update -y
sudo apt-get install -y temurin-17-jdk

# 2. Install Jenkins LTS
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y
sudo apt-get install -y jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins

# 3. Install Docker Engine
sudo apt-get install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker

# Add ubuntu and jenkins users to docker group
sudo usermod -aG docker ubuntu
sudo usermod -aG docker jenkins
sudo chmod 666 /var/run/docker.sock

# 4. Run SonarQube Container
docker run -d --name sonar-server -p 9000:9000 --restart always sonarqube:lts-community

# 5. Install Trivy Vulnerability Scanner
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo gpg --dearmor -o /usr/share/keyrings/trivy.gpg
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/trivy.list
sudo apt-get update -y
sudo apt-get install -y trivy
