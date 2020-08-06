provider "aws" {
  region = "us-east-1"
}

# Terraform state will be stored in S3
terraform {
  backend "s3" {
    bucket = "hlugo-terraform-backend"
    key    = "terraform-blue-green-pipeline/terraform.tfstate"
    region = "us-east-1"
  }
}