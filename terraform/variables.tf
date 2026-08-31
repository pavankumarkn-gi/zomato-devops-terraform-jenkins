variable "aws_region" {
  description = "AWS region for provisioning resources"
  type        = string
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "EC2 instance size required for Jenkins, SonarQube, and Docker"
  type        = string
  default     = "t2.large"
}

variable "key_name" {
  description = "Name of the existing EC2 Key Pair created in AWS"
  type        = string
  default     = "zomato-devops-key"
}

variable "volume_size" {
  description = "Root EBS storage volume size in GB"
  type        = number
  default     = 30
}
