output "keypair" {
  value = openstack_compute_keypair_v2.complete.private_key
}

output "public_ip" {
  value = try(module.complete_instance.public_ip, "")
}