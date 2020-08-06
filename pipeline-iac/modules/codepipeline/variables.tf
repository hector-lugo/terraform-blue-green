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

variable "artifact_bucket_arn" {
  description = "ARN of the bucket to store the artifacts on"
  type        = string
}

variable "artifact_bucket_name" {
  description = "Name of the bucket to store the artifacts on"
  type        = string
}

variable "repository_url" {
  description = "Clone url of the repository"
  type        = string
}

variable "repository_arn" {
  description = "ARN of the repository"
  type        = string
}

variable "repository_name" {
  description = "Name of the repository"
  type        = string
}

variable "codebuild_project" {
  description = "Clone url of the repository"
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