terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Specify a recent version
    }
  }
}

provider "aws" {
  region = var.aws_region
  # Other authentication mechanisms can be added here if needed
  # e.g., profile = "my-aws-profile"
}
