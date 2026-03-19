terraform {
  required_version = ">= 1.14"
  backend "s3" {
    bucket = "sctp-ce12-tfstate-bucket"
    key    = "terraform-cichecks.tfstate"
    region = "ap-southeast-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}