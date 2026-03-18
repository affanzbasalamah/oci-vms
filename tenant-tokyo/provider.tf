terraform {
  required_version = ">= 1.3"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 6.0"
    }
  }
}

provider "oci" {
  config_file_profile = "oci-jp-affan"
  region              = "ap-tokyo-1"
}
