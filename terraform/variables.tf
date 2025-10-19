# Credentials (input via terraform.tfvars)
variable "proxmox_api_url" {
  type = string
  sensitive = true
}
variable "proxmox_token_id" {
  type = string
  sensitive = true
}
variable "proxmox_token_secret" {
  type = string
  sensitive = true
}

# VM Configuration
variable "kube_count" {
  description = "Number of kube VMs"
  type        = number
  default     = 3
}

variable "node_name" {
  type = string
  default = "pve" 
}
variable "template_name" {
  type = string
  default = "ubuntu-20.04-template" 
}
variable "kube_cores" {
  type = number
  default = 2 
}
variable "kube_memory" {
  type = number
  default = 2048 
}
variable "disk_size" {
  type = string
  default = "20G" 
}
variable "storage_pool" {
  type = string
  default = "local-lvm" 
}
variable "network_bridge" {
  type = string
  default = "vmbr0" 
}
variable "cloudinit_user" {
  type = string
  default = "ubuntu" 
}
variable "ssh_public_key" {
  type = string
  default = "" 
}
# VMID Prefix
variable "vmid_prefix" {
  description = "Prefix for VM IDs (e.g., 3200 -> 32001, 32002)"
  type        = string
  default     = "3200"
  validation {
    condition     = can(tonumber(var.vmid_prefix)) && length(var.vmid_prefix) >= 3
    error_message = "vmid_prefix must be a valid number with at least 3 digits."
  }
}

# IP Configuration
variable "ip_prefix" {
  description = "IP address prefix (e.g., 192.168.1.10 for 192.168.1.101, etc.)"
  type        = string
  default     = "192.168.1.10"
}

variable "ip_subnet" {
  description = "IP address subnet (e.g., 16 for 192.168.1.0/16, etc)"
  type        = string
  default     = "24"
}

variable "ip_gateway" {
  description = "Gateway IP for the network"
  type        = string
  default     = "192.168.1.1"
}
