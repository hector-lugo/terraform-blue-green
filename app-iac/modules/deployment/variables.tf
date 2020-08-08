variable "vpc_id" {
  description = "Id of the VPC to deploy to"
  type        = string
}

variable "alb_subnets" {
  description = "List of subnets supported by the load balancer"
  type        = list(string)
}

variable "server_subnets" {
  description = "List of subnets supported by the web servers"
  type        = list(string)
}

variable "deployment_name" {
  description = "Name to prefix the resources with"
  type = string
}

variable "ami_id" {
  description = "AMI to use for the deployment"
  type = string
}

variable "instance_type" {
  description = "Instance type to use for the deployment"
  type = string
}