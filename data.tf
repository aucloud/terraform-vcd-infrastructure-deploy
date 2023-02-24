/*
	Copyright (C) 2023 Sovereign Cloud Australia Pty. Ltd.
	All rights reserved.
*/

locals {
  linux_password = bcrypt(var.linux_password_cleartext)
}

data "vcd_org_vdc" "nsxt_vdc" {
  name = var.vdc
}

data "vcd_nsxt_edgegateway" "edge_gateway" {
  owner_id = data.vcd_org_vdc.nsxt_vdc.id
  name     = var.edge_gateway
}

data "vcd_nsxt_alb_edgegateway_service_engine_group" "first" {
  org = var.org

  service_engine_group_name = "ALB-SE-Group-001"
  edge_gateway_id           = data.vcd_nsxt_edgegateway.edge_gateway.id
}

data "vcd_catalog" "catalog" {
  org  = var.org
  name = "demo"
}

data "vcd_catalog_vapp_template" "template_win" {
  org        = var.org
  catalog_id = data.vcd_catalog.catalog.id
  name       = var.template_win
}

data "vcd_catalog_vapp_template" "template_linux" {
  org        = var.org
  catalog_id = data.vcd_catalog.catalog.id
  name       = var.template_linux
}

data "vcd_nsxt_app_port_profile" "DNS-UDP" {
  scope = "SYSTEM"
  name  = "DNS-UDP"
}

data "vcd_nsxt_app_port_profile" "DNS-TCP" {
  scope = "SYSTEM"
  name  = "DNS"
}

data "vcd_nsxt_app_port_profile" "HTTP" {
  scope = "SYSTEM"
  name  = "HTTP"
}

data "vcd_nsxt_app_port_profile" "HTTPS" {
  scope = "SYSTEM"
  name  = "HTTPS"
}

data "vcd_nsxt_app_port_profile" "SSH" {
  scope = "SYSTEM"
  name  = "SSH"
}

data "vcd_nsxt_app_port_profile" "RDP" {
  scope = "SYSTEM"
  name  = "RDP"
}

data "vcd_nsxt_app_port_profile" "MS-SQL-S" {
  scope = "SYSTEM"
  name  = "MS-SQL-S"
}