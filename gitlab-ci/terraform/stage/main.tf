provider "yandex" {
  version                  = "0.35"
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

module "vpc" {
  source = "../modules/vpc"
  zone = var.zone
}

module "kubernetes" {
  source          = "../modules/kubernetes"
  public_key_path = var.public_key_path
  zone = var.zone
  service_account_id      = var.service_account_id
  cores  = var.cores
  memory = var.memory
  disk = var.disk
  node_count = var.node_count
  network_id       = module.vpc.vpc_network_id
  subnet_id       = module.vpc.vpc_subnet_id
}


module "postgresql" {
  source          = "../modules/postgresql"
  zone = var.zone
  network_id       = module.vpc.vpc_network_id
  subnet_id       = module.vpc.vpc_subnet_id
}

