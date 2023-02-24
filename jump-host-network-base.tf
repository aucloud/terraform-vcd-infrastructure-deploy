/*
	Copyright (C) 2023 Sovereign Cloud Australia Pty. Ltd.
	All rights reserved.
*/

resource "vcd_network_routed_v2" "jumphost" {
  org             = var.org
  name            = "Jump-host-cluster"
  description     = "Jump host subnet"
  edge_gateway_id = data.vcd_nsxt_edgegateway.edge_gateway.id
  gateway         = "${var.jumphost_addr}.1"
  prefix_length   = 24
}
resource "vcd_nsxt_network_dhcp" "jumphost" {
  org_network_id = vcd_network_routed_v2.jumphost.id

  pool {
    start_address = "${var.jumphost_addr}.10"
    end_address   = "${var.jumphost_addr}.100"
  }
  dns_servers = [var.dns1, var.dns2]
}
resource "vcd_nsxt_ip_set" "networkIPs_jumphost" {

  edge_gateway_id = data.vcd_nsxt_edgegateway.edge_gateway.id
  name            = "Jump-host-Cluster"
  description     = "IP set for jumphost network ${var.jumphost_addr}.0/24"
  ip_addresses    = ["${var.jumphost_addr}.0/24"]
}
resource "vcd_vapp" "jumphost_app" {
  name = "jump-host"
}
resource "vcd_vapp_org_network" "jumphost" {
  vapp_name        = vcd_vapp.jumphost_app.name
  org_network_name = vcd_network_routed_v2.jumphost.name
}
resource "vcd_nsxt_ip_set" "jumphost_appliance_ip" {
  edge_gateway_id = data.vcd_nsxt_edgegateway.edge_gateway.id

  name         = "jumphost-appliance"
  description  = "IP Set for VM"
  ip_addresses = [vcd_vapp_vm.jumphost_win.network[0].ip]
}
resource "vcd_nsxt_ip_set" "external-jumphost" {

  edge_gateway_id = data.vcd_nsxt_edgegateway.edge_gateway.id

  name        = "external-source-jumphost"
  description = "IP Set for DNAT External Source"

  ip_addresses = [
    "${var.jumphost_public_ip}"
  ]
}
resource "vcd_nsxt_ip_set" "ip_jumphost" {

  edge_gateway_id = data.vcd_nsxt_edgegateway.edge_gateway.id

  name        = "jump-host-IP"
  description = "IP Set for jumphost"

  ip_addresses = [
    var.jumphost_public_ip
  ]
}
resource "vcd_nsxt_nat_rule" "SNAT-jumphost" {
  org = var.org

  edge_gateway_id = data.vcd_nsxt_edgegateway.edge_gateway.id

  name        = "SNAT-Jump host to internet"
  rule_type   = "SNAT"
  description = "Jump host to internet"

  external_address = var.jumphost_public_ip
  internal_address = "${var.jumphost_addr}.0/24"

  logging = true
}
resource "vcd_nsxt_nat_rule" "DNAT-jumphost" {
  depends_on = [vcd_vapp_vm.jumphost_win]

  org             = var.org
  edge_gateway_id = data.vcd_nsxt_edgegateway.edge_gateway.id

  name        = "DNAT-ssh to jump host"
  rule_type   = "DNAT"
  description = "ssh to jump host"

  external_address = var.jumphost_public_ip
  internal_address = vcd_vapp_vm.jumphost_win.network[0].ip

  dnat_external_port = 22

  logging = true
}