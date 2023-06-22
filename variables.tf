variable "name" {
  description = "Name to be used on instance created"
  type        = string
}

variable "flavor_name" {
  description = "The flavor of the instance to start"
  type        = string
  default     = "m1_c1_m2_d20"
}

variable "key_pair_name" {
  description = "Key name of the Key Pair to use for the instance"
  type        = string
  default     = null
}

variable "image_id" {
  description = "ID of the image to use"
  type        = string
}

variable "availability_zone" {
  description = "AZ to start the instance in"
  type        = string
  default     = null
}

variable "stop_before_destroy" {
  description = "Stop the instance before destroying it"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "block_device_volume_size" {
  description = "Volume size (in GB) of the block device"
  type        = number
  default     = 20
}

variable "block_device_delete_on_termination" {
  description = "Delete block device when instance is shut down"
  type        = bool
  default     = true
}

variable "scheduler_hints" {
  description = "A map of scheduler hints to use"
  type        = any
  default     = {}
}

variable "ports" {
  description = "List of ports to bound to the instance"
  type = list(object({
    name               = string
    network_id         = string
    subnet_id          = string
    admin_state_up     = bool
    security_group_ids = list(string)
  }))
}

variable "is_public" {
  description = "Connect the instance to public network"
  type        = bool
  default     = false
}

variable "public_ip_network" {
  description = "The name of the network who give floating IPs"
  type        = string
  default     = "public"
}
