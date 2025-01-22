module "network" {
    source = "./modules/vpc"
    avz = var.avz
    vpc_id = module.network.vpc_id
    vpc_cidr = "10.20.0.0/16"
    sub_cidr = "10.20.0.0/24"
    
}

module "ec2" {
  source = "./modules/ec2"
  subnet_id = module.network.subnet_id
  instance_type = var.instance_type
  security_id = module.security.security_id
  ami = var.ami
}
module "security" {
    source = "./modules/security"
    vpc_id = module.network.vpc_id
}





