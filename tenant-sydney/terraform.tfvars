# ── Sydney Tenant (AU-sydney profile) ───────────────────────────────────────
# Fill in values from:
#   oci iam compartment list --profile AU-sydney --all
#   oci iam availability-domain list --profile AU-sydney
#   oci compute image list --profile AU-sydney --compartment-id <tenancy-ocid> \
#     --operating-system "Canonical Ubuntu" --operating-system-version "24.04" \
#     --shape "VM.Standard.E2.1.Micro" --query "data[0].id" --raw-output
#   oci compute image list --profile AU-sydney --compartment-id <tenancy-ocid> \
#     --operating-system "Canonical Ubuntu" --operating-system-version "24.04" \
#     --shape "VM.Standard.A1.Flex" --query "data[0].id" --raw-output

compartment_ocid    = "ocid1.tenancy.oc1..REPLACE_ME"
availability_domain = "REPLACE_ME:AP-SYDNEY-1-AD-1"
ssh_public_key_path = "~/.ssh/id_rsa.pub"

ubuntu2404_x86_image_id = "ocid1.image.oc1.ap-sydney-1.REPLACE_ME_X86"
ubuntu2404_arm_image_id = "ocid1.image.oc1.ap-sydney-1.REPLACE_ME_ARM"

# Ampere A1 free-tier allocation (max 4 OCPU + 24 GB across all A1 instances in tenancy)
a1_ocpus         = 2
a1_memory_in_gbs = 12
