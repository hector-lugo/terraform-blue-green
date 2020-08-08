module "network" {
  source = "./modules/network"
}

module "blue_env" {
  source = "./modules/deployment"
  vpc_id = module.network.vpc_id
  alb_subnets = module.network.public_subnets
  server_subnets = module.network.private_subnets
  deployment_name = "blue-env"
  ami_id = var.blue_env_ami_id
  instance_type = "t2.micro"
}

module "green_env" {
  source = "./modules/deployment"
  vpc_id = module.network.vpc_id
  alb_subnets = module.network.public_subnets
  server_subnets = module.network.private_subnets
  deployment_name = "green-env"
  ami_id = var.blue_env_ami_id
  instance_type = "t2.micro"
}

module "blue_route" {
  source = "./modules/routing"
  set_identifier = "blue"
  dns_record = "tbg.benevity-poc.org"
  hosted_zone = "benevity-poc.org"
  load_balancer_dns = module.blue_env.load_balancer_dns
  load_balancer_zone_id = module.blue_env.load_balancer_zone_id
  weight = 50
}

module "green_route" {
  source = "./modules/routing"
  set_identifier = "green"
  dns_record = "tbg.benevity-poc.org"
  hosted_zone = "benevity-poc.org"
  load_balancer_dns = module.green_env.load_balancer_dns
  load_balancer_zone_id = module.green_env.load_balancer_zone_id
  weight = 50
}