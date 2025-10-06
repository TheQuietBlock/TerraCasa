terraform {
  required_version = ">= 1.6"
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.2-rc04"
    }
  }
}

provider "proxmox" {
  pm_api_url          = var.proxmox_api_url
  pm_api_token_id     = var.proxmox_token_id
  pm_api_token_secret = var.proxmox_token_secret
  pm_tls_insecure     = var.proxmox_tls_insecure
}

# Create VLANs
resource "proxmox_vm_qemu" "vms" {
  for_each = local.vms

  name        = each.value.name
  vmid        = each.value.vmid
  target_node = var.proxmox_node
  clone       = var.template_name

  # VM Configuration
  memory = each.value.memory
  
  # SeaBIOS Configuration (matches template)
  bios = "seabios"
  machine = "pc-i440fx-6.1"
  
  # CPU Configuration
  cpu {
    cores   = each.value.cores
    sockets = 1
    type    = "host"
  }

  # Disk Configuration - Primary disk on SCSI
  disk {
    slot         = "scsi0"
    type         = "disk"
    storage      = var.storage_name
    size         = "32G"
    iothread     = true
    discard      = true
  }

  # Cloud-init drive on IDE2
  disk {
    slot    = "ide2"
    type    = "cloudinit"
    storage = var.storage_name
  }

  # EFI Disk for OVMF - will be created automatically with OVMF

  # Network Configuration - no VLAN tag for server network (VLAN 55)
  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
    # No tag needed for VLAN 55 (server network)
  }

  # Cloud-init Configuration
  ciuser     = var.vm_user
  cipassword = var.vm_password
  sshkeys    = var.ssh_public_key
  ciupgrade  = true

  # IP Configuration - Use static IP from configuration
  ipconfig0 = "ip=${each.value.ip_address}/${var.vlan_configs[each.value.vlan].subnet_cidr},gw=${var.vlan_configs[each.value.vlan].gateway}"

  # Boot order: SCSI disk first, then cloud-init, then network
  boot = "order=scsi0;ide2;net0"

  # Agent for better integration
  agent = 1
  agent_timeout = 30

  # SCSI Controller
  scsihw = "virtio-scsi-pci"
  
  # Timeout configuration
  clone_wait = 30

  # Lifecycle - Safe updates for existing VMs
  lifecycle {
    ignore_changes = [
      # Network configuration - don't touch existing network settings
      network,
      # Disk configuration - don't modify existing disks
      disk,
      # Cloud-init settings - don't change user/password/keys
      ciuser,
      cipassword,
      sshkeys,
      ipconfig0,
      # Template and cloning - don't change the base template
      clone,
      # VM ID - keep existing VMIDs
      vmid,
      # Additional attributes that might cause recreation
      full_clone,
      scsihw,
      agent,
      define_connection_info,
      description,
      onboot,
      target_nodes,
      smbios,
      # More attributes to prevent recreation
      boot,
      bootdisk,
      current_node,
      linked_vmid,
      numa,
      qemu_os,
      reboot_required,
      skip_ipv4,
      skip_ipv6,
      ssh_host,
      ssh_port,
      target_node,
      vm_state,
      # CPU and memory blocks
      cpu,
      disks,
      # BIOS settings
      bios,
      machine
    ]
    # Allow updates to cores and memory without recreation
    # Don't prevent destroy - allow controlled updates
  }

  # Tags for environment and usage identification
  tags = "${each.value.environment},${each.value.usage}"

  depends_on = []
}
