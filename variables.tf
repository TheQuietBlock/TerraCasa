# Proxmox Configuration
variable "proxmox_api_url" {
  description = "Proxmox API URL"
  type        = string
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
  default     = "storage"
}

# Cloud-init Configuration

variable "ssh_public_key" {
  description = "SSH public key for cloud-init"
  type        = string
}

variable "vm_user" {
  description = "VM user name for cloud-init"
  type        = string
}

variable "vm_password" {
  description = "VM user password for cloud-init"
  type        = string
  sensitive   = true
}

variable "management_networks" {
  description = "CIDR blocks that require administrative SSH access"
  type        = list(string)
  default     = []
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
    # Example structure - replace with your actual values in terraform.tfvars
    home = {
      vlan_id     = 150
      subnet      = "192.168.xx.0/24"
      subnet_cidr = "24"
      gateway     = "192.168.xx.1"
      description = "Home network"
    }
    server = {
      vlan_id     = 155
      subnet      = "192.168.xx.0/24"
      subnet_cidr = "24"
      gateway     = "192.168.xx.1"
      description = "Server network"
    }
  }
}

# VM IP Addresses
variable "vm_ip_addresses" {
  description = "IP addresses for VMs"
  type        = map(string)
  default = {
    # Example structure - replace with your actual values in terraform.tfvars
    "prox-n-roll"           = "192.168.xx.10"
    "resolver-of-truth"     = "192.168.xx.53"
    "minecraft-java-srv001" = "192.168.xx.50"
    "minecraft-java-srv002" = "192.168.xx.51"
    "port-and-order"        = "192.168.xx.80"
    "sir-flows-a-lot"       = "192.168.xx.85"
  }
}
