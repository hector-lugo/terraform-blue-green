variable "weight" {
  description = "Weight to assign to the record"
  type = number
}

variable "load_balancer_dns" {
  description = "Load balancer dns"
  type = string
}

variable "load_balancer_zone_id" {
  description = "Load balancer zone id"
  type = string
}

variable "hosted_zone" {
  description = "Hosted zone to add the record to"
  type = string
}

variable "dns_record" {
  description = "DNS record"
  type = string
}

variable "set_identifier" {
  description = "Set identifier, must be unique"
  type = string
}