locals {
  # All servers consolidated with usage tags
  vms = {
    resolver = {
      name        = "resolver-of-truth"
      vmid        = 101
      cores       = 4
      memory      = 2048
      vlan        = "server"
      ip_address  = var.vm_ip_addresses["resolver-of-truth"]
      os_type     = "ubuntu"
      description = "DNS resolver server"
      environment = "production"
      usage       = "dns"
    }
    minecraft-java-srv002 = {
      name        = "minecraft-java-srv002"
      vmid        = 111
      cores       = 4
      memory      = 8192
      vlan        = "server"
      ip_address  = var.vm_ip_addresses["minecraft-java-srv002"]
      os_type     = "ubuntu"
      description = "Minecraft server (Secondary)"
      environment = "production"
      usage       = "gaming"
    }
    Traefik = {
      name        = "port-and-order"
      vmid        = 120
      cores       = 2
      memory      = 2048
      vlan        = "server"
      ip_address  = var.vm_ip_addresses["port-and-order"]
      os_type     = "ubuntu"
      description = "Traefik reverse proxy"
      environment = "production"
      usage       = "automation"
    }
    webserver = {
      name        = "Cache-Me-Outside"
      vmid        = 130
      cores       = 2
      memory      = 2048
      vlan        = "web"
      ip_address  = var.vm_ip_addresses["Cache-Me-Outside"]
      os_type     = "ubuntu"
      description = "Web server"
      environment = "production"
      usage       = "web"
    }
  }

  # Existing VMs that must be imported but never changed by Terraform
  protected_vm_keys = toset([
    "resolver",
    "minecraft-java-srv002",
    "Traefik"
  ])

  # Split VM definitions into protected and normally managed groups
  protected_vms = {
    for k, v in local.vms : k => v
    if contains(local.protected_vm_keys, k)
  }

  managed_vms = {
    for k, v in local.vms : k => v
    if !contains(local.protected_vm_keys, k)
  }

  # Common tags
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "TerraCasa"
  }
}
