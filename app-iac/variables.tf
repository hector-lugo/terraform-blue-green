variable "left_env_ami_id" {
  description = "AMI to use for the left deployment"
  type = string
  default = "ami-09d95fab7fff3776c"
}

variable "left_env_routing_weight" {
  description = "Weight to assign to the left environment"
  type = number
  default = 100
}

variable "left_env_enabled" {
  description = "Whether or not the left environmnet should be deployed"
  type = bool
  default = true
}

variable "right_env_routing_weight" {
  description = "Weight to assign to the right environment"
  type = number
  default = 0
}

variable "right_env_ami_id" {
  description = "AMI to use for the right deployment"
  type = string
  default = "ami-09d95fab7fff3776c"
}

variable "right_env_enabled" {
  description = "Whether or not the right environmnet should be deployed"
  type = bool
  default = false
}