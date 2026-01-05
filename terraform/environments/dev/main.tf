terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Configure Helm provider to manage releases in this cluster
provider "helm" {
  kubernetes {
    host                   = module.eks_cluster.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks_cluster.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.eks_cluster.cluster_name, "--region", var.aws_region]
      command     = "aws"
    }
  }
}

module "eks_cluster" {
  source = "../../modules/eks_cluster"

  aws_region          = var.aws_region
  environment         = var.environment
  cluster_name        = var.cluster_name
  vpc_cidr            = var.vpc_cidr
  node_instance_type  = var.node_instance_type
  desired_size        = var.desired_size
  min_size            = var.min_size
  max_size            = var.max_size
  capacity_type       = var.capacity_type
  kubernetes_version  = var.kubernetes_version
}


