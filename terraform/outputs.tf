output "instance_public_ip" {
  description = "Public IP address of the EC2 DevSecOps instance"
  value       = aws_instance.zomato_server.public_ip
}

output "jenkins_url" {
  description = "Jenkins CI/CD Dashboard URL"
  value       = "http://${aws_instance.zomato_server.public_ip}:8080"
}

output "sonarqube_url" {
  description = "SonarQube Server URL"
  value       = "http://${aws_instance.zomato_server.public_ip}:9000"
}

output "zomato_app_url" {
  description = "Zomato Web App Deployment URL"
  value       = "http://${aws_instance.zomato_server.public_ip}:3000"
}
