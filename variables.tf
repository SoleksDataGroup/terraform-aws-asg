// Module: aws/asg
// Descriprion: module input variables
//

variable "name_prefix" {
  description = "Autoscale group name prefix"
  type = string
  default = "asg"
}

variable "vpc_id" {
  description = "Autoscale group VPC ID"
  type = string
  default = ""
}

variable "group_min_size" {
  description = "Autoscale group minimum size per availability zone"
  type = number
  default = 1
}

variable "group_max_size" {
  description = "Autoscale group maximum size per availability zone"
  type = number
  default = 1
}

variable "group_desired_capacity" {
  description = "Autoscale group desired capacity per availability zone"
  type = number
  default = 1
}

variable "protect_from_scale_in" {
  description = "Whether newly launched instances are automatically protected from termination by Amazon EC2 Auto Scaling when scaling in."
  type = bool
  default = false
}

variable "ami_name" {
  description = "Service group AMI name"
  type = string
  default = ""
}

variable "instance_type" {
  description = "Autoscale group instance type"
  type = string
  default = ""
}

variable "block_device_name" {
  description = "Name of the additional block device"
  type = string
  default = "/dev/sdb"
}

variable "block_device_type" {
  description = "Type of the additional block device"
  type = string
  default = "gp2"
}

variable "block_device_size" {
  description = "Size of the additional block device (in GB)."
  type = number
  default = 8
}

variable "block_device_delete_on_termination" {
  description = "Whether the volume should be destroyed on instance termination."
  type = bool
  default = true
}

variable "instance_iam_profile_arn" {
  description = "Autoscale group instance iam profile arn"
  type = string
  default = ""
}

variable "subnet_ids" {
  description = "Autoscale group subnet IDs"
  type = list(string)
  default = []
}

variable "dns_zone_id" {
  description = "DNS zone id"
  type = string
  default = ""
}

variable "tags" {
  description = "Additional tags"
  type = map
  default = {}
}

variable "target_group_arns" {
  description = "Target group ARNs to attach to service group ASG"
  type = list
  default = []
}

variable "security_group_ingress" {
  description = "Ingress traffic security rules"
  type = list(object({
    protocol = string
    from_port = number
    to_port = number
    cidr_blocks = optional(list(string))
    description = optional(string)
    ipv6_cidr_blocks = optional(list(string))
    prefix_list_ids = optional(list(string))
    security_groups = optional(list(string))
    self = optional(string)
  }))
  default = []
}

variable "security_group_egress" {
  description = "Engress traffic security rules"
  type = list(object({
    protocol = string
    from_port = number
    to_port = number
    cidr_blocks = optional(list(string))
    description = optional(string)
    ipv6_cidr_blocks = optional(list(string))
    prefix_list_ids = optional(list(string))
    security_groups = optional(list(string))
    self = optional(string)
  }))
  default = []
}

variable "user_data" {
  description = "Cloudinit userdata in base64 format"
  type = string
  default = ""
}

variable "warm_pool_enabled" {
  description = "Enable warm pool for ASG. Default is 'no'."
  type = bool
  default = false
}

variable "warm_pool_state" {
  description = "Instance state in warm pool. Possible values - 'Hibernated', 'Stopped', 'Running'."
  type = string
  default = "Hibernated"
}

variable "warm_pool_min_size" {
  description = "Minimum number of instances to maintain in the warm pool."
  type = number
  default = 0
}

variable "warm_pool_prepared_capacity" {
  description = "Total maximum number of instances that are allowed to be in the warm pool or in any state except Terminated for the Auto Scaling group"
  type = number
  default = 0
}

variable "reuse_on_scale_in" {
  description = "Whether instances in the Auto Scaling group can be returned to the warm pool on scale in."
  type = bool
  default = true
}
