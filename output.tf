output "public_ip" {
  description = "The public IP address assigned to the instance"
  value       = try(openstack_networking_floatingip_v2.this[0].address, "")
}

output "private_ip" {
  description = "The private IP address assigned to the instance."
  value       = try(openstack_compute_instance_v2.this.access_ip_v4, "")
}

output "id" {
  description = "The ID of the instance"
  value       = try(openstack_compute_instance_v2.this.id, "")
}

output "instance_state" {
  description = "The state of the instance. One of: `pending`, `running`, `shutting-down`, `terminated`, `stopping`, `stopped` or `error`"
  value       = try(openstack_compute_instance_v2.this.power_state, "")
}
