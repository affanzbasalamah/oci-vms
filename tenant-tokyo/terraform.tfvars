# ── Tokyo Tenant (oci-jp-affan profile) ──────────────────────────────────────

compartment_ocid    = "ocid1.tenancy.oc1..aaaaaaaa23kcrrocemlwp6ued3senzuukfkcj7n67jj35iiim2mwn6fk2rfq"
availability_domain = "GXeT:AP-TOKYO-1-AD-1"
ssh_public_key_path = "~/.ssh/id_ed25519.pub"

# Ubuntu 24.04 x86_64 — Canonical-Ubuntu-24.04-2026.04.30-1 (latest)
ubuntu2404_x86_image_id = "ocid1.image.oc1.ap-tokyo-1.aaaaaaaaoscw5alszu4h62xmlf2d3vusfpyyfxpooqxouff5wyc4w5g7e5bq"

# Ubuntu 24.04 aarch64 — Canonical-Ubuntu-24.04-aarch64-2026.04.30-1 (latest)
ubuntu2404_arm_image_id = "ocid1.image.oc1.ap-tokyo-1.aaaaaaaac6xgrmnpr676gm356kgsf2lr23e2e5ik6oigfuno3ybz3nul5riq"

# Ampere A1 free-tier allocation (max 4 OCPU + 24 GB across all A1 instances in tenancy)
a1_ocpus         = 1
a1_memory_in_gbs = 6

# Extra ports for wg-easy (WireGuard VPN + web UI)
extra_tcp_ports = [51821]
extra_udp_ports = [51820]
