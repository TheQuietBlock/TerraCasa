locals {
  # All servers consolidated with usage tags
  vms = {
    automation = {
      name           = "prox-n-roll"
      vmid           = 100
      cores          = 4
      memory         = 2048
      vlan           = "server"
      ip_address     = var.vm_ip_addresses["prox-n-roll"]
      os_type        = "ubuntu"
      cloudinit_file = "cloudinit/ubuntu-cloudinit.yaml"
      description    = "Automation server"
      environment    = "production"
      usage          = "automation"
    }
    resolver = {
      name           = "resolver-of-truth"
      vmid           = 101
      cores          = 4
      memory         = 2048
      vlan           = "server"
      ip_address     = var.vm_ip_addresses["resolver-of-truth"]
      os_type        = "ubuntu"
      cloudinit_file = "cloudinit/ubuntu-cloudinit.yaml"
      description    = "DNS resolver server"
      environment    = "production"
      usage          = "dns"
    }
    minecraft-java-srv001 = {
      name           = "minecraft-java-srv001"
      vmid           = 110
      cores          = 4
      memory         = 8192
      vlan           = "server"
      ip_address     = var.vm_ip_addresses["minecraft-java-srv001"]
      os_type        = "ubuntu"
      cloudinit_file = "cloudinit/ubuntu-cloudinit.yaml"
      description    = "Minecraft server (Primary)"
      environment    = "production"
      usage          = "gaming"
    }
    minecraft-java-srv002 = {
      name           = "minecraft-java-srv002"
      vmid           = 111
      cores          = 4
      memory         = 8192
      vlan           = "server"
      ip_address     = var.vm_ip_addresses["minecraft-java-srv002"]
      os_type        = "ubuntu"
      cloudinit_file = "cloudinit/ubuntu-cloudinit.yaml"
      description    = "Minecraft server (Secondary)"
      environment    = "production"
      usage          = "gaming"
    }
    n8n = {
      name           = "sir-flows-a-lot"
      vmid           = 115
      cores          = 2
      memory         = 2048
      vlan           = "server"
      ip_address     = var.vm_ip_addresses["sir-flows-a-lot"]
      os_type        = "ubuntu"
      cloudinit_file = "cloudinit/ubuntu-cloudinit.yaml"
      description    = "Minecraft server (Secondary)"
      environment    = "production"
      usage          = "automation"
    }
    Traefik = {
      name           = "port-and-order"
      vmid           = 120
      cores          = 2
      memory         = 2048
      vlan           = "server"
      ip_address     = var.vm_ip_addresses["port-and-order"]
      os_type        = "ubuntu"
      cloudinit_file = "cloudinit/ubuntu-cloudinit.yaml"
      description    = "Minecraft server (Secondary)"
      environment    = "production"
      usage          = "automation"
    }
  }

  # Common tags
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "TerraCasa"
  }
}
