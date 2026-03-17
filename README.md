# OCI Multi-Tenant VM Project

Terraform project for provisioning Ubuntu 24.04 VMs across **3 Oracle Cloud Infrastructure (OCI) tenants** using always-free shapes.

## Tenants

| Directory | OCI Profile | Region | Auth Method |
|-----------|-------------|--------|-------------|
| `tenant-singapore/` | `DEFAULT` | ap-singapore-1 | Session token |
| `tenant-sydney/` | `AU-sydney` | ap-sydney-1 | API key (OICS) |
| `tenant-tokyo/` | `JP-tokyo` | ap-tokyo-1 | Session token |

## VMs Created Per Tenant

Each tenant gets **2 always-free VMs**:

| VM | Shape | Arch | OS | Free Tier |
|----|-------|------|----|-----------|
| `*-amd-vm` | VM.Standard.E2.1.Micro | x86_64 | Ubuntu 24.04 | 2 per tenancy |
| `*-a1-vm` | VM.Standard.A1.Flex | aarch64 | Ubuntu 24.04 | 4 OCPU / 24 GB per tenancy |

## Prerequisites

- [OCI CLI](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm) installed and configured
- [Terraform](https://www.terraform.io/) >= 1.3
- SSH key pair at `~/.ssh/id_rsa` (or update `ssh_public_key_path` in tfvars)

## Step 1 — Authenticate OCI CLI Profiles

Ensure all 3 profiles have valid sessions before running Terraform:

```bash
# Singapore (DEFAULT profile)
oci session authenticate --profile DEFAULT --region ap-singapore-1
# or refresh: oci session refresh --profile DEFAULT

# Sydney
oci session authenticate --profile AU-sydney --region ap-sydney-1

# Tokyo
oci session authenticate --profile JP-tokyo --region ap-tokyo-1

# Verify each
oci iam region list --profile DEFAULT
oci iam region list --profile AU-sydney
oci iam region list --profile JP-tokyo
```

## Step 2 — Get Image OCIDs Per Tenant

Ubuntu 24.04 image OCIDs differ per region. Run per tenant profile:

```bash
PROFILE=DEFAULT   # change to AU-sydney or JP-tokyo
TENANCY=$(oci iam compartment list --profile $PROFILE --all --query "data[0].\"compartment-id\"" --raw-output)

# Ubuntu 24.04 x86_64 (for E2.1.Micro)
oci compute image list --profile $PROFILE \
  --compartment-id $TENANCY \
  --operating-system "Canonical Ubuntu" \
  --operating-system-version "24.04" \
  --shape "VM.Standard.E2.1.Micro" \
  --sort-by TIMECREATED --sort-order DESC \
  --query "data[0].id" --raw-output

# Ubuntu 24.04 aarch64 (for A1.Flex)
oci compute image list --profile $PROFILE \
  --compartment-id $TENANCY \
  --operating-system "Canonical Ubuntu" \
  --operating-system-version "24.04" \
  --shape "VM.Standard.A1.Flex" \
  --sort-by TIMECREATED --sort-order DESC \
  --query "data[0].id" --raw-output

# Availability domain
oci iam availability-domain list --profile $PROFILE \
  --query "data[0].name" --raw-output
```

Copy the OCIDs into each `terraform.tfvars`.

## Step 3 — Fill in terraform.tfvars

Edit each tenant's `terraform.tfvars` and replace all `REPLACE_ME` placeholders:

```
tenant-singapore/terraform.tfvars
tenant-sydney/terraform.tfvars
tenant-tokyo/terraform.tfvars
```

## Step 4 — Apply Per Tenant

```bash
# Singapore
cd tenant-singapore
terraform init
terraform plan
terraform apply

# Sydney
cd ../tenant-sydney
terraform init && terraform plan && terraform apply

# Tokyo
cd ../tenant-tokyo
terraform init && terraform plan && terraform apply
```

## Module Structure

```
.
├── modules/
│   └── vm/           # Shared module: VCN, IGW, subnet, security list, 2 VMs
├── tenant-singapore/ # DEFAULT OCI profile
├── tenant-sydney/    # AU-sydney OCI profile
└── tenant-tokyo/     # JP-tokyo OCI profile
```

## SSH Access

After `terraform apply`, get the public IPs from outputs:

```bash
terraform output amd_public_ip   # x86_64 VM
terraform output a1_public_ip    # aarch64 VM

ssh ubuntu@<public-ip>
```
