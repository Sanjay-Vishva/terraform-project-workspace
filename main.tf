terraform {
  backend "s3" {
    bucket         = "my-terraform-workspace-states"
    key            = "global/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

module "vpc" {
  source      = "./modules/vpc"
  vpc_cidr    = var.vpc_cidr
  availability_zone = data.aws_availability_zones.available.names[0]
  environment = var.environment
}

module "ec2" {
  source         = "./modules/ec2"
  subnet_id      = module.vpc.subnet_id
  instance_type  = var.instance_type
  environment    = var.environment
  availability_zone = data.aws_availability_zones.available.names[0]
}

data "aws_availability_zones" "available" {
  state = "available"
}
