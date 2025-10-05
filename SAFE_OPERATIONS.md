# Safe Terraform Operations Guide

This guide explains how to safely manage your existing servers without causing downtime or recreation.
 
## 🛡️ What's Protected

The current configuration protects existing servers from:
- **Network changes** (IP addresses, VLAN assignments)
- **Disk modifications** (size, storage location)
- **Cloud-init changes** (user accounts, SSH keys, passwords)
- **Template changes** (base OS template)
- **VM ID changes**

## ✅ What Can Be Safely Updated

You can safely modify these attributes without recreating VMs:
- **CPU cores** (`cores`)
- **Memory** (`memory`)
- **Tags** (environment labels)
- **Description** (VM description)

## 🔧 Safe Operations

### 1. Adding Memory to Existing Servers

```hcl
# In locals.tf, update the memory value
minecraft-java-srv001 = {
  name           = "minecraft-java-srv001"
  vmid           = 110
  cores          = 4
  memory         = 12288  # Increased from 8192 to 12GB
  # ... rest unchanged
}
```

Then run:
```powershell
terraform plan  # Review changes
terraform apply # Apply memory increase
```

### 2. Adding CPU Cores

```hcl
# In locals.tf, update the cores value
minecraft-java-srv001 = {
  name           = "minecraft-java-srv001"
  vmid           = 110
  cores          = 6  # Increased from 4 to 6
  memory         = 8192
  # ... rest unchanged
}
```

### 3. Adding New Servers

Use the `new_servers.tf` file:

```hcl
# Uncomment and modify in new_servers.tf
resource "proxmox_vm_qemu" "new_server" {
  name        = "new-server-name"
  vmid        = 200  # Use a new VMID
  target_node = var.proxmox_node
  clone       = var.template_name

  cores   = 2
  memory  = 2048
  # ... rest of configuration
}
```

### 4. Updating Tags

```hcl
# In locals.tf, update tags
minecraft-java-srv001 = {
  # ... other config
  environment = "production"
  # Add custom tags
  custom_tags = ["minecraft", "gaming"]
}
```

## ⚠️ What Will Cause Recreation

**NEVER** change these attributes for existing VMs:
- `vmid` (VM ID)
- `name` (VM name)
- `ip_address` (IP address)
- `vlan` (VLAN assignment)
- `clone` (base template)
- Network configuration
- Disk configuration

## 🔄 Workflow for Safe Updates

1. **Always run `terraform plan` first**
   ```powershell
   terraform plan
   ```
   Look for "forces replacement" warnings

2. **If you see "forces replacement"**
   - **STOP** - this will recreate the VM
   - Revert the change
   - Use a different approach

3. **For safe changes**
   ```powershell
   terraform apply
   ```

## 📋 Example: Adding Memory to Minecraft Server

```powershell
# 1. Edit locals.tf to increase memory
# Change: memory = 8192
# To:     memory = 12288

# 2. Plan the changes
terraform plan
# Should show: "memory: 8192 -> 12288"
# Should NOT show: "forces replacement"

# 3. Apply if plan looks good
terraform apply
```

## 🆕 Adding New Servers

1. **Edit `new_servers.tf`**
   - Uncomment the example resource
   - Set a new VMID (not in use)
   - Configure as needed

2. **Plan and apply**
   ```powershell
   terraform plan
   terraform apply
   ```

## 🚨 Emergency Procedures

### If Terraform Wants to Recreate a VM

1. **STOP** - don't run `terraform apply`
2. **Check the plan output** for what's causing recreation
3. **Revert the change** that's causing the issue
4. **Use `terraform refresh`** to sync state if needed

### If You Accidentally Changed a Protected Attribute

1. **Revert the change** in your configuration
2. **Run `terraform refresh`** to sync with actual state
3. **Run `terraform plan`** to verify no changes

## 🔍 Monitoring Changes

Always check the plan output for:
- ✅ `~` (update in-place) - **SAFE**
- ❌ `-/+` (destroy and recreate) - **DANGEROUS**
- ➕ `+` (create new) - **OK for new resources**
- ➖ `-` (destroy) - **DANGEROUS for existing resources**

## 📝 Best Practices

1. **Always use `terraform plan`** before `apply`
2. **Keep backups** of your VMs before major changes
3. **Test changes** in acceptance environment first
4. **Use version control** for your Terraform files
5. **Document changes** in commit messages

## 🆘 Getting Help

If you're unsure about a change:
1. Run `terraform plan` and review the output
2. Look for "forces replacement" warnings
3. If in doubt, ask before applying
4. Test in acceptance environment first
