variable "broker_semp_url" {
  type        = string
  default     = "https://localhost:1943"
  description = "The SEMP URL of the broker instance"
}

variable "broker_semp_username" {
  type        = string
  default     = "admin"
  description = "The username for SEMP of the broker instance"
}

variable "broker_semp_password" {
  type        = string
  default     = "admin"
  sensitive   = true
  description = "The password for SEMP of the broker instance"
}

variable "broker_remote_node_name" {
  type        = string
  description = "The node name of the remote broker instance"
}

variable "broker_remote_address" {
  type        = string
  description = "The address of the remote broker instance"
}

variable "broker_cluster_name" {
  type        = string
  description = "The cluster name of the broker instance"
}

variable "broker_cluster_password" {
  type        = string
  default     = "cluster-password"
  sensitive   = true
  description = "The cluster password of the broker instance"
}

variable "broker_msg_vpn_name" {
  type        = string
  default     = "default"
  description = "The Message VPN name of the broker instance"
}

variable "broker_remote_msg_vpn_name" {
  type        = string
  default     = "default"
  description = "The Message VPN name of the remote broker instance"
}