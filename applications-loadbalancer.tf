/*
	Copyright (C) 2023 Sovereign Cloud Australia Pty. Ltd.
	All rights reserved.
*/

// NSX-T load balancing

resource "vcd_nsxt_alb_pool" "application_https" {
  depends_on      = [vcd_vapp_vm.application_web_win]
  org             = var.org
  name            = "application-https"
  edge_gateway_id = data.vcd_nsxt_edgegateway.edge_gateway.id
  default_port    = 443
  member {
    enabled    = true
    ip_address = vcd_vapp_vm.application_web_win.network[0].ip
    ratio      = 1
  }
  health_monitor {
    type = "TCP"
  }
}
resource "vcd_nsxt_alb_virtual_service" "application_web" {
  org = var.org

  name            = "global_VIP"
  edge_gateway_id = data.vcd_nsxt_edgegateway.edge_gateway.id

  pool_id                  = vcd_nsxt_alb_pool.application_https.id
  service_engine_group_id  = data.vcd_nsxt_alb_edgegateway_service_engine_group.first.service_engine_group_id
  virtual_ip_address       = var.application_public_vip
  ca_certificate_id        = ""
  application_profile_type = "HTTP"
  service_port {
    start_port = 80
    type       = "TCP_PROXY"
  }
}