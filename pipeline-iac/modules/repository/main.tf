resource "aws_codecommit_repository" "repository" {
  repository_name = "terraform-blue-green"
  description = "Repository for terraform blue/green POC"

  tags = {
    Project = "TerraformBlueGreen"
  }
}