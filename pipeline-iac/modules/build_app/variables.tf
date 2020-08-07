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

variable "project_name" {
  description = "Name of the project"
  type        = string
  default = "terraform-blue-green-project"
}

variable "pipeline_log_group_arn" {
  description = "Log group ARN for the pipeline in which the project is running"
  type        = string
}

variable "pipeline_log_group_name" {
  description = "Log group for the pipeline in which the project is running"
  type        = string
}

variable "log_group_arn" {
  description = "Log group for the project"
  type        = string
}

variable "artifact_bucket_arn" {
  description = "ARN of the bucket to store the artifacts on"
  type        = string
}

variable "terraform_backend_bucket_arn" {
  description = "ARN of the bucket storing the terraform state file"
  type        = string
}

variable "repository_arn" {
  description = "ARN of the repository"
  type        = string
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