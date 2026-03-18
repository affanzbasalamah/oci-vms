# ── Singapore Tenant (oci-sg-affan profile) ───────────────────────────────────

compartment_ocid    = "ocid1.tenancy.oc1..aaaaaaaaoehiyx6xmks7elybsawxc7kvkqtwksofs24qfqzhmbqnhuz6jm5q"
availability_domain = "HUZb:AP-SINGAPORE-1-AD-1"
ssh_public_key_path = "~/.ssh/id_ed25519.pub"

# Ubuntu 24.04 x86_64 — Canonical-Ubuntu-24.04-2026.02.28-0
ubuntu2404_x86_image_id = "ocid1.image.oc1.ap-singapore-1.aaaaaaaau6s26vibk7dykvfupb5djtxp2736hhk4qhy6y35ncq4l5otfak4q"

# Ubuntu 24.04 aarch64 — Canonical-Ubuntu-24.04-aarch64-2026.02.28-0 (latest)
ubuntu2404_arm_image_id = "ocid1.image.oc1.ap-singapore-1.aaaaaaaa3rjnbq273x5kzisyx6os5r57735jnhytwkmwx7c5gm4ybkvzi2ua"

# Ampere A1 — try 2 OCPU / 12 GB first (always-free quota: 4 OCPU / 24 GB total per tenancy)
# If terraform apply fails with InsufficientServiceLimits/Out of capacity, change to:
#   a1_ocpus         = 1
#   a1_memory_in_gbs = 6
a1_ocpus         = 2
a1_memory_in_gbs = 12
