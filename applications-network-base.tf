/*
	Copyright (C) 2023 Sovereign Cloud Australia Pty. Ltd.
	All rights reserved.
*/

resource "vcd_network_routed_v2" "application" {
  org             = var.org
  name            = "Application-cluster"
  description     = "Application subnet"
  edge_gateway_id = data.vcd_nsxt_edgegateway.edge_gateway.id
  gateway         = "${var.application_addr}.1"
  prefix_length   = 24
}
resource "vcd_nsxt_network_dhcp" "application" {
  org_network_id = vcd_network_routed_v2.application.id

  pool {
    start_address = "${var.application_addr}.10"
    end_address   = "${var.application_addr}.100"
  }
  dns_servers = [var.dns1, var.dns2]
}
resource "vcd_nsxt_ip_set" "ip_subnet_application" {

  edge_gateway_id = data.vcd_nsxt_edgegateway.edge_gateway.id
  name            = "Application-cluster"
  description     = "IP Set for application network ${var.application_addr}.0/24"
  ip_addresses    = ["${var.application_addr}.0/24"]
}
resource "vcd_vapp" "application_web" {
  name = "web"
}
resource "vcd_vapp_org_network" "application_web" {
  vapp_name        = vcd_vapp.application_web.name
  org_network_name = vcd_network_routed_v2.application.name
}
resource "vcd_vapp" "application_app" {
  name = "app"
}
resource "vcd_vapp_org_network" "application_apps" {
  vapp_name        = vcd_vapp.application_app.name
  org_network_name = vcd_network_routed_v2.application.name
}
resource "vcd_vapp" "application_utility" {
  name = "utility"
}
resource "vcd_vapp_org_network" "application_utility" {
  vapp_name        = vcd_vapp.application_utility.name
  org_network_name = vcd_network_routed_v2.application.name
}
resource "vcd_nsxt_ip_set" "application_appliance_ip" {
  edge_gateway_id = data.vcd_nsxt_edgegateway.edge_gateway.id

  name         = "Application-appliance"
  description  = "IP set for vm"
  ip_addresses = [vcd_vapp_vm.application_web_win.network[0].ip]
}
resource "vcd_nsxt_ip_set" "external-application" {

  edge_gateway_id = data.vcd_nsxt_edgegateway.edge_gateway.id

  name        = "External-source-application"
  description = "IP Set for DNAT external source"

  ip_addresses = [
    "${var.application_public_ip}"
  ]
}
resource "vcd_nsxt_ip_set" "vip_application" {

  edge_gateway_id = data.vcd_nsxt_edgegateway.edge_gateway.id

  name        = "application-VIP"
  description = "IP Set for VIP"

  ip_addresses = [
    var.application_public_vip
  ]
}
resource "vcd_nsxt_nat_rule" "SNAT-application" {
  org = var.org

  edge_gateway_id = data.vcd_nsxt_edgegateway.edge_gateway.id

  name        = "SNAT-Application to internet"
  rule_type   = "SNAT"
  description = "Application to internet"

  external_address = var.application_public_ip
  internal_address = "${var.application_addr}.0/24"

  logging = true
}
resource "vcd_nsxt_nat_rule" "DNAT-application" {
  depends_on = [vcd_vapp_vm.application_web_win]

  org             = var.org
  edge_gateway_id = data.vcd_nsxt_edgegateway.edge_gateway.id

  name        = "DNAT-Internet to application"
  rule_type   = "DNAT"
  description = "Internet to application"

  external_address = var.application_public_ip
  internal_address = vcd_vapp_vm.application_web_win.network[0].ip

  dnat_external_port = 443
  logging            = true
}