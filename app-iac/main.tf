module "network" {
  source = "./modules/network"
}

module "left_env" {
  source = "./modules/deployment"
  vpc_id = module.network.vpc_id
  alb_subnets = module.network.public_subnets
  server_subnets = module.network.private_subnets
  deployment_name = "left-env"
  ami_id = var.left_env_ami_id
  instance_type = "t2.micro"
  enabled = var.left_env_enabled
}

module "right_env" {
  source = "./modules/deployment"
  vpc_id = module.network.vpc_id
  alb_subnets = module.network.public_subnets
  server_subnets = module.network.private_subnets
  deployment_name = "right-env"
  ami_id = var.right_env_ami_id
  instance_type = "t2.micro"
  enabled = var.right_env_enabled
}

module "left_route" {
  source = "./modules/routing"
  set_identifier = "left"
  dns_record = "tbg.benevity-poc.org"
  hosted_zone = "benevity-poc.org"
  load_balancer_dns = module.left_env.load_balancer_dns
  load_balancer_zone_id = module.left_env.load_balancer_zone_id
  weight = var.left_env_routing_weight
  enabled = var.left_env_enabled
}

module "right_route" {
  source = "./modules/routing"
  set_identifier = "right"
  dns_record = "tbg.benevity-poc.org"
  hosted_zone = "benevity-poc.org"
  load_balancer_dns = module.right_env.load_balancer_dns
  load_balancer_zone_id = module.right_env.load_balancer_zone_id
  weight = var.right_env_routing_weight
  enabled = var.right_env_enabled
}