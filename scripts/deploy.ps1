# TerraCasa Deployment Script
# Usage: .\scripts\deploy.ps1 -Environment "production" -Action "plan"

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("acceptance", "production")]
    [string]$Environment,
    
    [Parameter(Mandatory=$true)]
    [ValidateSet("init", "plan", "apply", "destroy")]
    [string]$Action
)

# Set working directory to project root
$ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
$ProjectRoot = Split-Path -Parent $ScriptPath
Set-Location $ProjectRoot

Write-Host "TerraCasa Deployment Script" -ForegroundColor Green
Write-Host "Environment: $Environment" -ForegroundColor Yellow
Write-Host "Action: $Action" -ForegroundColor Yellow
Write-Host "Working Directory: $ProjectRoot" -ForegroundColor Cyan

# Copy environment-specific configuration
$EnvConfig = "environments\$Environment\terraform.tfvars"
if (Test-Path $EnvConfig) {
    Write-Host "Copying environment configuration..." -ForegroundColor Cyan
    Copy-Item $EnvConfig "terraform.tfvars" -Force
} else {
    Write-Error "Environment configuration not found: $EnvConfig"
    exit 1
}

# Execute Terraform command
switch ($Action) {
    "init" {
        Write-Host "Initializing Terraform..." -ForegroundColor Cyan
        terraform init
    }
    "plan" {
        Write-Host "Planning Terraform changes..." -ForegroundColor Cyan
        Write-Host "Checking for dangerous changes..." -ForegroundColor Yellow
        $planOutput = terraform plan -out=plan.tfplan
        $planOutput | Out-String | Write-Host
        
        # Check for dangerous changes
        if ($planOutput -match "forces replacement" -or $planOutput -match "destroy and create") {
            Write-Warning "DANGER: Plan shows resources will be recreated!"
            Write-Warning "This will cause downtime. Please review the plan carefully."
            Write-Host "If you want to proceed, run: terraform apply plan.tfplan" -ForegroundColor Red
        } else {
            Write-Host "Plan looks safe - no resources will be recreated" -ForegroundColor Green
        }
    }
    "apply" {
        Write-Host "Applying Terraform changes..." -ForegroundColor Cyan
        if (Test-Path "plan.tfplan") {
            Write-Host "Using saved plan file..." -ForegroundColor Yellow
            terraform apply plan.tfplan
            Remove-Item "plan.tfplan" -Force
        } else {
            Write-Host "No plan file found. Running apply directly..." -ForegroundColor Yellow
            Write-Warning "This is less safe. Consider running 'plan' first."
            terraform apply -auto-approve
        }
    }
    "destroy" {
        Write-Host "Destroying Terraform resources..." -ForegroundColor Red
        $confirmation = Read-Host "Are you sure you want to destroy all resources? (yes/no)"
        if ($confirmation -eq "yes") {
            terraform destroy -auto-approve
        } else {
            Write-Host "Destruction cancelled." -ForegroundColor Yellow
        }
    }
}

Write-Host "Deployment script completed." -ForegroundColor Green
