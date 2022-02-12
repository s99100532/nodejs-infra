locals {
  name        = "nodejs-infra"
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

module "networking" {
  source        = "./networking"
  ssh_limit_ips = ["0.0.0.0/0"]
}

module "iam" {
  source = "./iam"
}


module "ecs" {
  source             = "./ecs"
  app_name           = local.name
  ec2_subnet_ids     = module.networking.default_subnet_ids
  subnet_ids         = module.networking.default_subnet_ids
  vpc_id             = module.networking.default_vpc_id
  security_group_ids = [module.networking.default_security_group_id]
}

