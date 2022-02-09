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
  source = "./networking"
}

module "iam" {
  source = "./iam"
}


# module "ecs" {
#   source                 = "./ecs"
#   cluster_name           = local.name
#   ec2_subnet_id          = module.networking.default_subnet_id
#   ec2_key_name           = "nodejs-infra"
#   vpc_security_group_ids = [module.networking.default_security_group_id]
#   vpc_id                 = module.networking.default_vpc_id
# }
