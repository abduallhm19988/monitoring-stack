variable "instance_type" {
  description = "EC2 instance type for both control and target nodes"
  type        = string
  default     = "t2.medium"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "ami" {
  description = "AMI ID for EC2 instances"
  type        = string
  default     = "ami-0e1bed4f06a3b463d" # Ubuntu 22.04 LTS
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "ssh_key_name" {
  description = "Name of existing EC2 Key Pair"
  type        = string
  default     = "new"
}

variable "eks_cluster_name" {
  description = "Name for EKS cluster"
  type        = string
  default     = "monitoring-cluster"
}

variable "node_group_name" {
  description = "Name for EKS node group"
  type        = string
  default     = "monitoring-nodes"
}
