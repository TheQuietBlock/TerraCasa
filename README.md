# TerraCasa Homelab Infrastructure

This Terraform project manages your homelab infrastructure on Proxmox VE with a simplified, consolidated approach using usage-based tagging.

## Project Structure

```
TerraCasa/
├── cloudinit/
│   └── ubuntu-cloudinit.yaml   # Cloud-init template
├── main.tf                     # Main Terraform configuration
├── variables.tf                # Variable definitions
├── locals.tf                   # Server definitions with usage tags
├── outputs.tf                  # Output definitions
├── terraform.tfvars            # Configuration file
└── README.md                   # This file
```

## Server Configuration

All servers are managed in a single configuration with usage-based tagging:

| Server | VM ID | IP Address | Usage | Description |
|--------|-------|------------|-------|-------------|
| **prox-n-roll** | 100 | `192.168.xx.xx` | automation | Automation server |
| **resolver-of-truth** | 101 | `192.168.xx.xx` | dns | DNS resolver server |
| **minecraft-java-srv001** | 110 | `192.168.xx.xx` | gaming | Minecraft server (Primary) |
| **minecraft-java-srv002** | 111 | `192.168.xx.xx` | gaming | Minecraft server (Secondary) |
| **port-and-order** | 120 | `192.168.xx.xx` | automation | Traefik reverse proxy |
| **sir-flows-a-lot** | 115 | `192.168.xx.xx` | automation | n8n automation server |

### Usage Tags

- **automation**: Infrastructure automation and management
- **dns**: DNS resolution services
- **gaming**: Gaming servers and applications

## Prerequisites

1. **Proxmox VE** running and accessible
2. **Ubuntu Cloud-init Template** configured
3. **Terraform** installed
4. **Proxmox API Token** with appropriate permissions

## Setup Instructions

### 1. Configure Proxmox API Token

1. In Proxmox web interface, go to **Datacenter** → **Permissions** → **API Tokens**
2. Create a new token with:
   - User: `terraform@pve` (or your preferred user)
   - Token ID: `terraform-token`
   - Privilege Separation: Enabled
   - Expiration: Set as needed
3. Note down the token ID and secret

### 2. Configure Terraform

1. Copy the example configuration:
   ```powershell
   Copy-Item terraform.tfvars.example terraform.tfvars
   ```

2. Edit `terraform.tfvars` with your values:
   - **Proxmox API URL**: Replace `192.168.xx.xx` with your Proxmox server IP
   - **Proxmox API credentials**: Replace with your actual token ID and secret
   - **SSH public key**: Replace with your SSH public key
   - **Network settings**: Update VLAN configurations with your network ranges
   - **VM IP addresses**: Set your desired static IPs for each VM

   **Important**: The example file contains placeholder values that must be replaced with your actual network configuration.

### 3. Deploy Infrastructure

```powershell
# Initialize Terraform
terraform init

# Review planned changes
terraform plan

# Apply changes
terraform apply
```

## Network Configuration

The infrastructure supports multiple VLANs for network segmentation:

- **Home Network**: `192.168.xx.xx/24` - General purpose network
- **Server Network**: `192.168.xx.xx/24` - Infrastructure and services

### VM IP Addresses

| Server | IP Address | Usage |
|--------|------------|-------|
| **prox-n-roll** | `192.168.xx.xx` | automation |
| **resolver-of-truth** | `192.168.xx.xx` | dns |
| **minecraft-java-srv001** | `192.168.xx.xx` | gaming |
| **minecraft-java-srv002** | `192.168.xx.xx` | gaming |
| **port-and-order** | `192.168.xx.xx` | automation |
| **sir-flows-a-lot** | `192.168.xx.xx` | automation |

VM IP addresses are configurable through the `vm_ip_addresses` variable in `terraform.tfvars`.

### Configuration Structure

The project uses a two-tier configuration approach:

1. **`variables.tf`**: Defines variable types and provides documentation defaults
2. **`terraform.tfvars`**: Contains your actual values (gitignored for security)

**Example configuration structure:**
```hcl
# VLAN Configurations
vlan_configs = {
  home = {
    vlan_id     = 50
    subnet      = "192.168.xx.0/24"
    subnet_cidr = "24"
    gateway     = "192.168.xx.1"
    description = "Home network"
  }
  server = {
    vlan_id     = 55
    subnet      = "192.168.xx.0/24"
    subnet_cidr = "24"
    gateway     = "192.168.xx.1"
    description = "Server network"
  }
}

# VM IP Addresses
vm_ip_addresses = {
  "prox-n-roll"           = "192.168.xx.10"
  "resolver-of-truth"     = "192.168.xx.53"
  # ... more VMs
}
```

## Cloud-init Configuration

The `cloudinit/ubuntu-cloudinit.yaml` template configures:
- SSH key authentication
- Firewall rules
- System optimization
- Network configuration

## Terraform Commands

```powershell
# Initialize Terraform
terraform init

# Plan changes
terraform plan

# Apply changes
terraform apply

# Destroy infrastructure
terraform destroy

# Show current state
terraform show

# List resources
terraform state list
```

## Server Management

### Adding New Servers

1. Add server definition to `locals.tf` in the `vms` block
2. Assign a unique VM ID
3. Set appropriate usage tag
4. Configure network and resource settings
5. Run `terraform plan` to review changes
6. Apply with `terraform apply`

### Server Usage Tags

Usage tags help organize and identify server purposes:

```hcl
# Example server definition
automation = {
  name           = "server-name"
  vmid           = 200
  cores          = 4
  memory         = 4096
  vlan           = "server"
  ip_address     = var.vm_ip_addresses["server-name"]
  os_type        = "ubuntu"
  cloudinit_file = "cloudinit/ubuntu-cloudinit.yaml"
  description    = "Server description"
  environment    = "production"
  usage          = "automation"  # Usage tag
}
```

## Importing Existing Infrastructure

If you have existing VMs that need to be managed by Terraform:

```powershell
# Import existing VM
terraform import 'proxmox_vm_qemu.vms["server-name"]' VMID

# Verify import
terraform state show 'proxmox_vm_qemu.vms["server-name"]'
```

## Troubleshooting

### Common Issues

1. **API Connection Issues**
   - Verify Proxmox API URL and credentials
   - Check if `pm_tls_insecure = true` is set

2. **Template Not Found**
   - Ensure the Ubuntu cloud-init template exists
   - Verify template name matches `template_name` variable

3. **IP Address Conflicts**
   - Check if IP addresses are already in use
   - Verify VLAN configuration

4. **SSH Key Issues**
   - Ensure SSH public key is properly formatted
   - Check cloud-init template configuration

### Logs and Debugging

```powershell
# Enable debug logging
$env:TF_LOG = "DEBUG"
terraform apply

# Check Terraform state
terraform state show 'proxmox_vm_qemu.vms["server-name"]'
```

## Outputs

The configuration provides several useful outputs:

- **vms**: Complete VM information including usage tags
- **environment_summary**: Environment overview
- **network_info**: Network configuration details

## Security Notes

- Store sensitive variables in environment variables or use Terraform Cloud
- Regularly rotate Proxmox API tokens
- Keep Terraform state files secure
- Use strong passwords for cloud-init
- Never commit sensitive information to version control

## Contributing

When making changes:
1. Test configuration with `terraform plan` first
2. Update documentation
3. Follow Terraform best practices
4. Use meaningful commit messages
5. Ensure no sensitive information is included in commits

## Best Practices

- Use version control for all configuration files
- Keep `terraform.tfvars` in `.gitignore` if it contains sensitive data
- Use consistent naming conventions
- Document any custom configurations
- Regular backups of Terraform state files