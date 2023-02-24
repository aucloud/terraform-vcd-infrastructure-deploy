/*
	Copyright (C) 2023 Sovereign Cloud Australia Pty. Ltd.
	All rights reserved.
*/

# Secrets that are stored in github
variable "user" {}
variable "password" {}
variable "vdc" {}
variable "org" {}
variable "edge_gateway" {}
variable "url" {
  type = string
}

# General network
variable "dns1" {}
variable "dns2" {}

# Application network
variable "application_public_ip" {}
variable "application_public_vip" {}
variable "application_addr" {}

# Jumphost network
variable "jumphost_public_ip" {}
variable "jumphost_addr" {}

# Database network
variable "database_addr" {}

# VM details
variable "application_web_win" {}
variable "application_apps_win" {}
variable "application_utility_linux" {}
variable "jumphost_win" {}
variable "database_win" {}

# VM acount details
variable "win_password" {
  sensitive = true
}

variable "linux_user" {
  sensitive = true
}
variable "linux_password_cleartext" {
  sensitive = true
}

variable "catalog_name" {}
variable "template_linux" {}
variable "template_win" {}

variable "vcd_max_retry_timeout" {}
variable "vcd_allow_unverified_ssl" {}