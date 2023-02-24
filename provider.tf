/*
	Copyright (C) 2023 Sovereign Cloud Australia Pty. Ltd.
	All rights reserved.
*/
/*
    provider.tf
    Best practice  - put provider information here.
*/
terraform {
  required_providers {
    vcd = {
      source  = "vmware/vcd"
      version = "~> 3.8.2"
    }
  }

  backend "s3" {
  }
}

provider "vcd" {
  user                 = var.user
  password             = var.password
  org                  = var.org # Default for resources
  vdc                  = var.vdc # Default for resources
  url                  = var.url
  max_retry_timeout    = var.vcd_max_retry_timeout
  allow_unverified_ssl = var.vcd_allow_unverified_ssl
}