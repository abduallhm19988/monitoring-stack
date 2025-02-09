terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.82.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.30.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.13.2"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = var.region
  default_tags {
    tags = {
      Environment = "Monitoring"
      Project     = "Prometheus-Grafana"
    }
  }
}

provider "kubernetes" {
  host                   = aws_eks_cluster.monitoring.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.monitoring.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.monitoring.name]
    command     = "aws"
  }
}

provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.monitoring.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.monitoring.certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.monitoring.name]
      command     = "aws"
    }
  }
}
