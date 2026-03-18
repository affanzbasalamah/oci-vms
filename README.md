# OCI Multi-Tenant VM Project

Terraform project for provisioning Ubuntu 24.04 VMs across **3 Oracle Cloud Infrastructure (OCI) tenants** using always-free shapes.

## Tenants

| Directory | OCI Profile | Region | Auth Method |
|-----------|-------------|--------|-------------|
| `tenant-singapore/` | `oci-sg-affan` | ap-singapore-1 | Session token |
| `tenant-sydney/` | `oci-au-affan` | ap-sydney-1 | Session token |
| `tenant-tokyo/` | `oci-jp-affan` | ap-tokyo-1 | Session token |

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

Ensure all 3 profiles have valid sessions before running Terraform.
> **Note:** Always add `--auth security_token` for session-token profiles.

```bash
# Singapore
oci session authenticate --profile oci-sg-affan --region ap-singapore-1
# or refresh expired token:
oci session refresh --profile oci-sg-affan

# Sydney
oci session authenticate --profile oci-au-affan --region ap-sydney-1

# Tokyo
oci session authenticate --profile oci-jp-affan --region ap-tokyo-1

# Verify each
oci iam region list --profile oci-sg-affan --auth security_token
oci iam region list --profile oci-au-affan --auth security_token
oci iam region list --profile oci-jp-affan --auth security_token
```

## Step 2 — Get Image OCIDs Per Tenant

Ubuntu 24.04 image OCIDs differ per region. Run per tenant profile:

```bash
PROFILE=oci-sg-affan   # change to oci-au-affan or oci-jp-affan
TENANCY=$(oci iam compartment list --profile $PROFILE --auth security_token \
  --all --query "data[0].\"compartment-id\"" --raw-output)

# Ubuntu 24.04 x86_64 (for E2.1.Micro)
oci compute image list --profile $PROFILE --auth security_token \
  --compartment-id "$TENANCY" \
  --operating-system "Canonical Ubuntu" \
  --operating-system-version "24.04" \
  --shape "VM.Standard.E2.1.Micro" \
  --sort-by TIMECREATED --sort-order DESC \
  --query "data[0].id" --raw-output

# Ubuntu 24.04 aarch64 (for A1.Flex)
oci compute image list --profile $PROFILE --auth security_token \
  --compartment-id "$TENANCY" \
  --operating-system "Canonical Ubuntu" \
  --operating-system-version "24.04" \
  --shape "VM.Standard.A1.Flex" \
  --sort-by TIMECREATED --sort-order DESC \
  --query "data[0].id" --raw-output

# Availability domain
oci iam availability-domain list --profile $PROFILE --auth security_token \
  --query "data[0].name" --raw-output
```

Copy the OCIDs into each `terraform.tfvars`.

## Step 3 — Fill in terraform.tfvars

Edit each tenant's `terraform.tfvars` and replace all `REPLACE_ME` placeholders:

```
tenant-singapore/terraform.tfvars   ← already configured (see example below)
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
├── tenant-singapore/ # oci-sg-affan profile (ap-singapore-1)
├── tenant-sydney/    # oci-au-affan profile (ap-sydney-1)
└── tenant-tokyo/     # oci-jp-affan profile (ap-tokyo-1)
```

## SSH Access

After `terraform apply`, get the public IPs from outputs:

```bash
terraform output amd_public_ip   # x86_64 VM
terraform output a1_public_ip    # aarch64 VM

ssh ubuntu@<public-ip>
```

---

## Example: Deploying an ARM64 (aarch64) VM on OCI Singapore

This section documents the exact steps used to deploy `sg-a1-vm` — an Ampere A1
Ubuntu 24.04 aarch64 VM in the Singapore region.

### 1. Find available aarch64 images

```bash
# Store compartment OCID
COMPARTMENT=$(oci iam compartment list \
  --profile oci-sg-affan --auth security_token \
  --all --query "data[0].\"compartment-id\"" --raw-output)

# List Ubuntu 24.04 aarch64 images for A1.Flex
oci compute image list \
  --profile oci-sg-affan --auth security_token \
  --compartment-id "$COMPARTMENT" \
  --operating-system "Canonical Ubuntu" \
  --operating-system-version "24.04" \
  --shape "VM.Standard.A1.Flex" \
  --sort-by TIMECREATED --sort-order DESC \
  --query "data[*].{name:\"display-name\",id:id}" \
  --output table
```

**Output (ap-singapore-1, March 2026):**

```
+---------------------------------------------------------------------------------------------+---------------------------------------------+
| id                                                                                          | name                                        |
+---------------------------------------------------------------------------------------------+---------------------------------------------+
| ocid1.image.oc1.ap-singapore-1.aaaaaaaa3rjnbq273x5kzisyx6os5r57735jnhytwkmwx7c5gm4ybkvzi2ua | Canonical-Ubuntu-24.04-aarch64-2026.02.28-0 |
| ocid1.image.oc1.ap-singapore-1.aaaaaaaauzmcaxvcyzfmbppgh3w3cyhovjnrezpjv6tveuxkd4ri7od7fouq | Canonical-Ubuntu-24.04-aarch64-2026.01.29-0 |
| ocid1.image.oc1.ap-singapore-1.aaaaaaaaabcgip2rouii76kkuwfymjfrjykmt6qeyi5k7bizrmdijftfcbsa | Canonical-Ubuntu-24.04-aarch64-2025.10.31-0 |
+---------------------------------------------------------------------------------------------+---------------------------------------------+
```

### 2. Get availability domain

```bash
oci iam availability-domain list \
  --profile oci-sg-affan --auth security_token \
  --compartment-id "$COMPARTMENT" \
  --query "data[*].name" --output table
# → HUZb:AP-SINGAPORE-1-AD-1
```

### 3. Configure terraform.tfvars

```hcl
# tenant-singapore/terraform.tfvars
compartment_ocid    = "<tenancy-ocid>"
availability_domain = "HUZb:AP-SINGAPORE-1-AD-1"
ssh_public_key_path = "~/.ssh/id_rsa.pub"

# Latest Ubuntu 24.04 aarch64 image (Canonical-Ubuntu-24.04-aarch64-2026.02.28-0)
ubuntu2404_arm_image_id = "ocid1.image.oc1.ap-singapore-1.aaaaaaaa3rjnbq273x5kzisyx6os5r57735jnhytwkmwx7c5gm4ybkvzi2ua"

# A1.Flex config: try 2 OCPU / 12 GB first (free tier: 4 OCPU / 24 GB total per tenancy)
# If capacity unavailable, fall back to: a1_ocpus = 1, a1_memory_in_gbs = 6
a1_ocpus         = 2
a1_memory_in_gbs = 12
```

### 4. Deploy

```bash
cd tenant-singapore
terraform init
terraform plan   # verify: shape = VM.Standard.A1.Flex, ocpus = 2, memory = 12
terraform apply
```

### 5. Connect

```bash
ssh ubuntu@$(terraform output -raw a1_public_ip)

# Verify architecture on the VM
uname -m   # → aarch64
lscpu | grep "Architecture"
```

### Capacity fallback

If `terraform apply` fails with `Out of host capacity` or `InsufficientServiceLimits`,
edit `terraform.tfvars` and reduce the allocation:

```hcl
a1_ocpus         = 1
a1_memory_in_gbs = 6
```

Then re-run `terraform apply`.
