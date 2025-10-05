# Example: Safely Adding Memory to Existing Servers
# This shows how to update memory without recreating VMs

# Step 1: Update the memory value in locals.tf
# Change this:
# minecraft-java-srv001 = {
#   name           = "minecraft-java-srv001"
#   vmid           = 110
#   cores          = 4
#   memory         = 8192  # <-- Change this value
#   # ... rest unchanged
# }

# To this:
# minecraft-java-srv001 = {
#   name           = "minecraft-java-srv001"
#   vmid           = 110
#   cores          = 4
#   memory         = 12288  # <-- Increased to 12GB
#   # ... rest unchanged
# }

# Step 2: Run terraform plan to verify
# terraform plan
# Should show: "memory: 8192 -> 12288"
# Should NOT show: "forces replacement"

# Step 3: Apply if plan looks good
# terraform apply

# This will update the memory without recreating the VM
