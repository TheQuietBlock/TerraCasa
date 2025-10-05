# Proxmox Configuration
variable "proxmox_api_url" {
  description = "Proxmox API URL"
  type        = string
  default     = "https://192.168.55.5:8006/api2/json"
}

variable "proxmox_token_id" {
  description = "Proxmox API token ID"
  type        = string
  sensitive   = true
}

variable "proxmox_token_secret" {
  description = "Proxmox API token secret"
  type        = string
  sensitive   = true
}

variable "proxmox_tls_insecure" {
  description = "Skip TLS verification for Proxmox API"
  type        = bool
  default     = true
}

variable "proxmox_node" {
  description = "Proxmox node name"
  type        = string
  default     = "proxmox"
}

variable "template_name" {
  description = "Template name to clone from"
  type        = string
  default     = "ubuntu-cloudinit-template"
}

variable "storage_name" {
  description = "Storage name for VM disks"
  type        = string
  default     = "local-lvm"
}

# Cloud-init Configuration
variable "cloudinit_user" {
  description = "Cloud-init default user"
  type        = string
  default     = "ubuntu"
}

variable "cloudinit_password" {
  description = "Cloud-init default password"
  type        = string
  sensitive   = true
  default     = "changeme"
}

variable "ssh_public_key" {
  description = "SSH public key for cloud-init"
  type        = string
}

# Environment Configuration
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

# Network Configuration
variable "vlan_configs" {
  description = "VLAN configurations"
  type = map(object({
    vlan_id     = number
    subnet      = string
    subnet_cidr = string
    gateway     = string
    description = string
  }))
  default = {
    home = {
      vlan_id     = 50
      subnet      = "192.168.50.0/24"
      subnet_cidr = "24"
      gateway     = "192.168.50.1"
      description = "Home network"
    }
    server = {
      vlan_id     = 55
      subnet      = "192.168.55.0/24"
      subnet_cidr = "24"
      gateway     = "192.168.55.1"
      description = "Server network"
    }
  }
}

# VM IP Addresses
variable "vm_ip_addresses" {
  description = "IP addresses for VMs"
  type = map(string)
  default = {
    "prox-n-roll"           = "192.168.55.10"
    "resolver-of-truth"     = "192.168.55.53"
    "minecraft-java-srv001" = "192.168.55.50"
    "minecraft-java-srv002" = "192.168.55.51"
  }
}
