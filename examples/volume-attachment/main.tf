provider "openstack" {}

#
# Retrieve availability zones for computes
data "openstack_compute_availability_zones_v2" "all" {}

#
# Retrieve image information from OpenStack
data "openstack_images_image_v2" "ubuntu" {
  name        = "ubuntu-20.04"
  most_recent = true
}

#
# Create keypair
resource "openstack_compute_keypair_v2" "complete" {
  name = "complete-instance-keypair"
}

#
# Create server group with anti-affinity policy
resource "openstack_compute_servergroup_v2" "www" {
  name     = "www-complete"
  policies = ["anti-affinity"]
}

#
# VPC Module
module "complete_vpc" {
  source = "../../../terraform-openstack-vpc"

  name                = "complete-example"
  cidr                = "192.168.0.0/24"
  public_network_name = "public"

  tags = ["staging"]
}

#
# Security Groups Module
module "complete_sg" {
  source = "../../../terraform-openstack-security"

  name          = "complete-sg"
  ingress_cidr  = "0.0.0.0/0"
  ingress_rules = ["ssh-tcp"]
  tags          = ["staging"]
}

#
# Instance Module
module "complete_instance" {
  source = "../../"

  name              = "complete-instance"
  key_pair_name     = openstack_compute_keypair_v2.complete.name
  availability_zone = data.openstack_compute_availability_zones_v2.all.names[0]
  image_id          = data.openstack_images_image_v2.ubuntu.id
  is_public         = true
  scheduler_hints   = {
    group = [openstack_compute_servergroup_v2.www.id]
  }

  tags = {
    Environment = "dev"
  }

  ports = [
    {
      name               = "internal",
      network_id         = module.complete_vpc.network_id,
      subnet_id          = module.complete_vpc.subnet_id,
      security_group_ids = [module.complete_sg.security_group_id],
      admin_state_up     = true,
    }
  ]
}

#
# Create volume
resource "openstack_blockstorage_volume_v3" "this" {
  name        = "complete-instance_data"
  description = "Data volume"
  size        = 20
}

#
# Bound volume to instance
resource "openstack_compute_volume_attach_v2" "data" {
  instance_id = module.complete_instance.id
  volume_id   = openstack_blockstorage_volume_v3.this.id
}
