module "network" {
  source       = "./modules/network"
  network_name = "notes-network"
  subnet_cidr  = "10.0.0.0/24"
}