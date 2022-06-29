resource "openstack_compute_instance_v2" "this" {
  name                = var.name
  flavor_name         = var.flavor_name
  key_pair            = var.key_pair_name
  availability_zone   = var.availability_zone
  stop_before_destroy = var.stop_before_destroy

  metadata = merge(
    { managed_by = "Terraform" },
    var.tags,
  )

  block_device {
    uuid                  = var.image_id
    source_type           = "image"
    volume_size           = var.block_device_volume_size
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = var.block_device_delete_on_termination
  }

  dynamic "scheduler_hints" {
    for_each = var.server_groups_ids

    content {
      group = scheduler_hints.value
    }
  }

  dynamic "network" {
    for_each = openstack_networking_port_v2.this

    content {
      port = network.value["id"]
    }
  }

  lifecycle {
    ignore_changes = [
      image_name,                        # replace images only when planned
      availability_zone, scheduler_hints # apply only for new resources to allow gradual upgrade
    ]
  }
}

resource "openstack_networking_port_v2" "this" {
  count = length(var.ports)

  name               = var.ports[count.index].name
  network_id         = var.ports[count.index].network_id
  admin_state_up     = var.ports[count.index].admin_state_up
  security_group_ids = var.ports[count.index].security_group_ids

  fixed_ip {
    subnet_id = var.ports[count.index].subnet_id
  }
}

resource "openstack_networking_floatingip_v2" "this" {
  count = var.is_public ? 1 : 0

  pool = var.public_ip_network
}

resource "openstack_compute_floatingip_associate_v2" "this" {
  count = var.is_public ? 1 : 0

  floating_ip = openstack_networking_floatingip_v2.this[count.index].address
  instance_id = openstack_compute_instance_v2.this.id
}

# vim: ft=tf
