# TerraCasa Homelab Terraform

Terraform configuration for managing selected Proxmox VMs with cloud-init snippets and VLAN-aware networking.

## What This Repository Manages

- Proxmox provider configuration and VM definitions
- Cloud-init template rendering and snippet upload
- Split VM handling:
  - `proxmox_vm_qemu.vms` for normally managed VMs
  - `proxmox_vm_qemu.protected_vms` for imported immutable VMs (`ignore_changes = all`)

## Current VM Inventory

| Key | Name | VMID | Network | Usage | Management Mode |
|---|---|---:|---|---|---|
| `resolver` | `resolver-of-truth` | `101` | server VLAN | dns | protected |
| `minecraft-server` | `block-and-order` | `111` | server VLAN | gaming | protected |
| `Traefik` | `port-and-order` | `120` | server VLAN | automation | protected |
| `webserver` | `Cache-Me-Outside` | `130` | web VLAN | web | managed |

## Network Model (Sanitized)

- Home VLAN: `192.168.x.0/24`
- Server VLAN: `192.168.x.0/24`
- Web VLAN: `192.168.x.0/28`
- VM addresses are provided through `vm_ip_addresses` in `terraform.tfvars`

Do not commit real internal IP addresses or credentials to version control.

## Project Layout

```text
TerraCasa/
├── cloudinit/
│   └── ubuntu-cloudinit.yaml
├── main.tf
├── locals.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
└── README.md
```

## Quick Start

```powershell
terraform init
terraform plan
terraform apply
```

Always run `terraform plan` first and inspect for unsafe actions.

## Safe Change Rules

Safe in-place updates are typically:

- CPU cores
- Memory
- Tags
- Description

Do **not** change existing VM identity/network primitives unless you are intentionally replacing infrastructure:

- VMID
- Name (depends on resource behavior; verify with plan)
- IP configuration
- VLAN/network config
- Clone/template linkage
- Disk layout
- Cloud-init wiring

## How VM Grouping Works

VMs are defined once in `locals.tf` under `local.vms`, then split into:

- `local.protected_vms` using `local.protected_vm_keys`
- `local.managed_vms` for everything else

If you rename a VM key in `local.vms`, update `protected_vm_keys` to match the new key.

## Import Existing VMs

Example imports:

```powershell
terraform import 'proxmox_vm_qemu.protected_vms["resolver"]' 101
terraform import 'proxmox_vm_qemu.protected_vms["minecraft-server"]' 111
terraform import 'proxmox_vm_qemu.protected_vms["Traefik"]' 120
```

## Troubleshooting

- Provider/API issues: verify Proxmox URL/token values and TLS settings
- Cloud-init snippet issues: verify SSH access to Proxmox host and snippet path
- Unexpected replacement in plan (`-/+`): stop and review before apply

## Security Notes

- Keep `terraform.tfvars` out of version control when it contains secrets
- Rotate tokens/passwords regularly
- Never commit full internal IP plans, passwords, or token secrets
