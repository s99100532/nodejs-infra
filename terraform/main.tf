locals {
  name = "nodejs-infra"
  environment = "dev"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"

  backend "s3" {
    bucket = "nodejs-terraform-state"
    region = "ap-southeast-1"
  }
}
provider "aws" {
  region = "ap-southeast-1"

  default_tags {
    tags = {
      Environment = local.environment
      Project     = local.name
    }
  }
}


resource "aws_ecr_repository" "registry" {
  name = local.name
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = local.name

  cidr = "10.1.0.0/16"

  azs             = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
  private_subnets = ["10.1.1.0/24", "10.1.2.0/24"]
  public_subnets  = ["10.1.11.0/24", "10.1.12.0/24"]

  enable_nat_gateway = false # false is just faster

  tags = {
    Environment = local.environment
    Name        = local.name
  }
}
