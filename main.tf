provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "my-k8s-cluster"
  cluster_version = "1.21"
  vpc_id          = aws_vpc.main_vpc.id
  subnets         = [aws_subnet.main_subnet.id]
  node_groups = {
    eks_nodes = {
      desired_capacity = 2
      max_size         = 3
      min_size         = 1
      instance_types   = ["t3.medium"]
    }
  }
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}
