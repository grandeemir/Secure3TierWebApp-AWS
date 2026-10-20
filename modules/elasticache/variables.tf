variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "security_group_id" {
  type = string
}

variable "node_type" {
  type = string
}

variable "num_cache_nodes" {
  type = number
}

variable "automatic_failover_enabled" {
  type = bool
}

variable "multi_az_enabled" {
  type = bool
}

variable "tags" {
  type = map(string)
}

variable "engine" {
  type = string
}

variable "engine_version" {
  type = string
}