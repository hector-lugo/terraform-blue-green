# Input variable definitions

variable "prefix" {
  description = "Prefix to attach to resources"
  type        = string
  default     = "Hlugo"
}

variable "pipeline_name" {
  description = "Name of the pipeline"
  type        = string
}

variable "build_project_name" {
  description = "Name of the build project"
  type        = string
  default = "terraform-blue-green-project"
}

variable "deploy_project_name" {
  description = "Name of the deployment project"
  type        = string
  default = "terraform-blue-green-deployment-project"
}

variable "tags" {
  description = "Tags to apply to resources created by the module"
  type        = map(string)
  default     = {
    Terraform   = "true"
    Environment = "dev"
    Project = "TerraformBlueGreen"
  }
}