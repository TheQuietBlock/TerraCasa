# VM Information
output "vms" {
  description = "Information about created VMs"
  value = {
    for k, v in proxmox_vm_qemu.vms : k => {
      name        = v.name
      vmid        = v.vmid
      ip_address  = v.ipconfig0
      vm_state    = v.vm_state
      tags        = v.tags
      usage       = local.vms[k].usage
      description = local.vms[k].description
    }
  }
}

# Environment Summary
output "environment_summary" {
  description = "Summary of the current environment"
  value = {
    environment = var.environment
    vm_count    = length(proxmox_vm_qemu.vms)
    vms         = keys(proxmox_vm_qemu.vms)
  }
}

# Network Information
output "network_info" {
  description = "Network configuration information"
  value = {
    vlans = var.vlan_configs
    vm_ips = {
      for k, v in proxmox_vm_qemu.vms : k => v.ipconfig0
    }
  }
}