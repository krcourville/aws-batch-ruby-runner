terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 1.1.5"
}

provider "aws" {
  profile = "default"
  region  = var.region

  default_tags {
    tags = {
      terraform = "true"
      env       = var.app_env
      app       = var.app_name
      team      = var.team
      org       = var.org
      code_repo = var.code_repo
    }
  }
}

locals {
  prefix = "${var.app_env}-${var.org}-${var.team}-${var.app_name}"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all_default_subnets" {
  vpc_id = data.aws_vpc.default.id
}
