/*
	Copyright (C) 2023 Sovereign Cloud Australia Pty. Ltd.
	All rights reserved.
*/

resource "vcd_nsxt_firewall" "fabric_fw" {
  org = var.org

  edge_gateway_id = data.vcd_nsxt_edgegateway.edge_gateway.id

  // DNAT External sources to internal subnet on granted ports
  rule {
    name                 = "DNAT-External-to-Application"
    direction            = "IN"
    action               = "ALLOW"
    source_ids           = [vcd_nsxt_ip_set.external-application.id]
    destination_ids      = [vcd_nsxt_ip_set.application_appliance_ip.id]
    app_port_profile_ids = [data.vcd_nsxt_app_port_profile.HTTPS.id, data.vcd_nsxt_app_port_profile.HTTP.id]
    ip_protocol          = "IPV4"
  }
  // Internal network to internet
  rule {
    name        = "Jump-host-to-internet"
    direction   = "OUT"
    action      = "ALLOW"
    source_ids  = [vcd_nsxt_ip_set.networkIPs_jumphost.id]
    ip_protocol = "IPV4"
  }
  // DNAT External sources to internal subnet on granted
  rule {
    name                 = "DNAT-External-to-jump-host"
    direction            = "IN_OUT"
    action               = "ALLOW"
    source_ids           = [vcd_nsxt_ip_set.external-jumphost.id]
    destination_ids      = [vcd_nsxt_ip_set.jumphost_appliance_ip.id]
    app_port_profile_ids = [data.vcd_nsxt_app_port_profile.SSH.id, data.vcd_nsxt_app_port_profile.RDP.id]
    ip_protocol          = "IPV4"
  }
  // Internal jump host subnet to internal application subnet on granted
  rule {
    name                 = "Internal-jump-host-to-application"
    direction            = "IN_OUT"
    action               = "ALLOW"
    source_ids           = [vcd_nsxt_ip_set.jumphost_appliance_ip.id]
    destination_ids      = [vcd_nsxt_ip_set.application_appliance_ip.id]
    app_port_profile_ids = [data.vcd_nsxt_app_port_profile.SSH.id, data.vcd_nsxt_app_port_profile.RDP.id]
    ip_protocol          = "IPV4"
  }
  // Internal application subnet to Internal database subnet on granted
  rule {
    name                 = "Internal-application-to-database"
    direction            = "IN"
    action               = "ALLOW"
    source_ids           = [vcd_nsxt_ip_set.application_appliance_ip.id]
    destination_ids      = [vcd_nsxt_ip_set.database_appliance_ip.id]
    app_port_profile_ids = [data.vcd_nsxt_app_port_profile.SSH.id, data.vcd_nsxt_app_port_profile.RDP.id, data.vcd_nsxt_app_port_profile.MS-SQL-S.id]
    ip_protocol          = "IPV4"
  }
}