# OpenStack Compute Terraform Module

## Usage

### Single instance

```hcl
module "compute" {
  source = "./modules/terraform-openstack-modules/terraform-openstack-compute"

  name              = "my-instance"
  key_pair_name     = "my-keypair"
  availability_zone = "az-a"
  image_id          = "46c8e29f-3b36-4751-8624-6a40a6c9bc0c"
  server_groups_ids = ["70d20f6a-2944-4eab-8788-40953dadd155"]
  is_public         = true

  tags = {
    Environment = "staging"
  }

  ports = [
    {
      name               = "internal",
      network_id         = "cd9e4ef6-55bd-413f-aa11-13ab557c4607",
      subnet_id          = "48cd68e6-2eb8-4130-b63a-a89a4fdd3f2b",
      security_group_ids = ["70d20f6a-2944-4eab-8788-40953dadd155"],
      admin_state_up     = true,
    }
  ]
}
```

### Multiple instances

```hcl
data "openstack_compute_availability_zones_v2" "all" {}

module "compute" {
  source = "./modules/terraform-openstack-modules/terraform-openstack-compute"

  count             = 3
  name              = format("my-instance-%02d", count.index)
  key_pair_name     = "my-keypair"
  availability_zone = element(data.openstack_compute_availability_zones_v2.all.names, count.index)
  image_id          = "46c8e29f-3b36-4751-8624-6a40a6c9bc0c"
  server_groups_ids = ["70d20f6a-2944-4eab-8788-40953dadd155"]
  is_public         = true

  tags = {
    Environment = "staging"
  }

  ports = [
    {
      name               = "internal",
      network_id         = "cd9e4ef6-55bd-413f-aa11-13ab557c4607",
      subnet_id          = "48cd68e6-2eb8-4130-b63a-a89a4fdd3f2b",
      security_group_ids = ["70d20f6a-2944-4eab-8788-40953dadd155"],
      admin_state_up     = true,
    }
  ]
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.0 |
| <a name="requirement_openstack"></a> [openstack](#requirement\_openstack) | >= 1.35.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_openstack"></a> [openstack](#provider\_openstack) | >= 1.35.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [openstack_compute_floatingip_associate_v2.this](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/compute_floatingip_associate_v2) | resource |
| [openstack_compute_instance_v2.this](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/compute_instance_v2) | resource |
| [openstack_networking_floatingip_v2.this](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/networking_floatingip_v2) | resource |
| [openstack_networking_port_v2.this](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/networking_port_v2) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | AZ to start the instance in | `string` | `null` | no |
| <a name="input_block_device_delete_on_termination"></a> [block\_device\_delete\_on\_termination](#input\_block\_device\_delete\_on\_termination) | Delete block device when instance is shut down | `bool` | `true` | no |
| <a name="input_block_device_volume_size"></a> [block\_device\_volume\_size](#input\_block\_device\_volume\_size) | Volume size (in GB) of the block device | `number` | `20` | no |
| <a name="input_flavor_name"></a> [flavor\_name](#input\_flavor\_name) | The flavor of the instance to start | `string` | `"m1_c1_m2_d20"` | no |
| <a name="input_image_id"></a> [image\_id](#input\_image\_id) | ID of the image to use | `string` | n/a | yes |
| <a name="input_is_public"></a> [is\_public](#input\_is\_public) | Connect the instance to public network | `bool` | `false` | no |
| <a name="input_key_pair_name"></a> [key\_pair\_name](#input\_key\_pair\_name) | Key name of the Key Pair to use for the instance | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name to be used on instance created | `string` | n/a | yes |
| <a name="input_ports"></a> [ports](#input\_ports) | List of ports to bound to the instance | <pre>list(object({<br>    name               = string<br>    network_id         = string<br>    subnet_id          = string<br>    admin_state_up     = bool<br>    security_group_ids = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_public_ip_network"></a> [public\_ip\_network](#input\_public\_ip\_network) | The name of the network who give floating IPs | `string` | `"public"` | no |
| <a name="input_server_groups_ids"></a> [server\_groups\_ids](#input\_server\_groups\_ids) | IDs of server groups | `list(string)` | `[]` | no |
| <a name="input_stop_before_destroy"></a> [stop\_before\_destroy](#input\_stop\_before\_destroy) | Stop the instance before destroying it | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the instance |
| <a name="output_instance_state"></a> [instance\_state](#output\_instance\_state) | The state of the instance. One of: `pending`, `running`, `shutting-down`, `terminated`, `stopping`, `stopped` or `error` |
| <a name="output_private_ip"></a> [private\_ip](#output\_private\_ip) | The private IP address assigned to the instance. |
| <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip) | The public IP address assigned to the instance |
