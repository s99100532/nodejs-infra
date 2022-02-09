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
  profile = "david"
  region  = "ap-southeast-1"

  default_tags {
    tags = {
      Environment = "dev"
      Project     = "nodejs-infra"
    }
  }
}


resource "aws_ecr_repository" "registry" {
  name = "nodejs-infra"
}
