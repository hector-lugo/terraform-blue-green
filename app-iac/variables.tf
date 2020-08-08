variable "blue_env_ami_id" {
  description = "AMI to use for the blue deployment"
  type = string
  default = "ami-09d95fab7fff3776c"
}

variable "blue_env_routing_weight" {
  description = "Weight to assign to the blue environment"
  type = number
  default = 100
}

variable "green_env_routing_weight" {
  description = "Weight to assign to the green environment"
  type = number
  default = 0
}

variable "green_env_ami_id" {
  description = "AMI to use for the blue deployment"
  type = string
  default = "ami-09d95fab7fff3776c"
}