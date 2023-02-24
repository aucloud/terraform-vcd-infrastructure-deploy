/*
	Copyright (C) 2023 Sovereign Cloud Australia Pty. Ltd.
	All rights reserved.
*/

resource "vcd_network_routed_v2" "database" {
  org             = var.org
  name            = "Database-cluster"
  description     = "database subnet"
  edge_gateway_id = data.vcd_nsxt_edgegateway.edge_gateway.id
  gateway         = "${var.database_addr}.1"
  prefix_length   = 24
}
resource "vcd_nsxt_network_dhcp" "database" {
  org_network_id = vcd_network_routed_v2.database.id

  pool {
    start_address = "${var.database_addr}.10"
    end_address   = "${var.database_addr}.100"
  }
  dns_servers = [var.dns1, var.dns2]
}
resource "vcd_nsxt_ip_set" "ip_subnet_database" {

  edge_gateway_id = data.vcd_nsxt_edgegateway.edge_gateway.id
  name            = "Database-cluster"
  description     = "IP Set for Database network ${var.database_addr}.0/24"
  ip_addresses    = ["${var.database_addr}.0/24"]
}
resource "vcd_vapp" "database_app" {
  name = "database"
}
resource "vcd_vapp_org_network" "database" {
  vapp_name        = vcd_vapp.database_app.name
  org_network_name = vcd_network_routed_v2.database.name
}
resource "vcd_nsxt_ip_set" "database_appliance_ip" {
  edge_gateway_id = data.vcd_nsxt_edgegateway.edge_gateway.id

  name         = "Database-appliance"
  description  = "IP Set for VM"
  ip_addresses = [vcd_vapp_vm.database_win.network[0].ip]
}