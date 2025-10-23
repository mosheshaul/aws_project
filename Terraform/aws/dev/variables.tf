variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS CLI profile to use"
  type        = string
  default     = "aws_project"
}

variable "vpc_id" {
  description = "Target VPC"
  type        = string
  default     = "vpc-07269b8322ffa871a"
}

variable "public_subnet_id" {
  description = "A PUBLIC subnet ID in the target VPC"
  type        = string
}

variable "my_ip" {
  description = "Your public IP (without /32), e.g. 31.168.22.44"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}
