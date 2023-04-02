/*
   Copyright 2023 Sovereign Cloud Australia Pty. Ltd

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

*/

/*
    Terraform files when run are concantenated.
    The files are broken down in a best practice way.
*/


resource "time_sleep" "destroy_minute" {
  depends_on = [
    vcd_network_routed_v2.application, vcd_network_routed_v2.jumphost, vcd_network_routed_v2.database
  ]

  destroy_duration = "60s"
}

#Application VM details
resource "vcd_vapp_vm" "application_web_win" {
  depends_on = [
    time_sleep.destroy_minute

  ]
  name             = var.application_web_win
  computer_name    = var.application_web_win
  vapp_name        = vcd_vapp.application_web.name
  vapp_template_id = data.vcd_catalog_vapp_template.template_win.id


  memory    = 8192
  cpus      = 2
  cpu_cores = 2

  override_template_disk {
    bus_type    = "paravirtual"
    size_in_mb  = "102400.0"
    bus_number  = 0
    unit_number = 0
    iops        = 2000
  }

  network_dhcp_wait_seconds = 300
  network {
    name               = vcd_vapp_org_network.application_web.org_network_name
    type               = "org"
    adapter_type       = "VMXNET3"
    ip_allocation_mode = "DHCP"
    is_primary         = true
  }

  customization {
    allow_local_admin_password          = true
    auto_generate_password              = false
    admin_password                      = var.win_password
    must_change_password_on_first_login = false
    enabled                             = true
    initscript = templatefile("cloudinit/runonce.tmpl", {
      "application_subnet" = var.application_addr,
      "jumphost_subnet"    = var.jumphost_addr,
      "database_subnet"    = var.database_addr
    })
  }
}

resource "vcd_vapp_vm" "application_apps_win" {
  depends_on = [
    time_sleep.destroy_minute

  ]
  name             = var.application_apps_win
  computer_name    = var.application_apps_win
  vapp_name        = vcd_vapp.application_app.name
  vapp_template_id = data.vcd_catalog_vapp_template.template_win.id

  memory    = 8192
  cpus      = 2
  cpu_cores = 2

  override_template_disk {
    bus_type    = "paravirtual"
    size_in_mb  = "102400.0"
    bus_number  = 0
    unit_number = 0
    iops        = 2000
  }

  network_dhcp_wait_seconds = 300
  network {
    name               = vcd_vapp_org_network.application_apps.org_network_name
    type               = "org"
    adapter_type       = "VMXNET3"
    ip_allocation_mode = "DHCP"
    is_primary         = true
  }

  customization {
    allow_local_admin_password          = true
    auto_generate_password              = false
    admin_password                      = var.win_password
    must_change_password_on_first_login = false
    enabled                             = true
    initscript = templatefile("cloudinit/runonce.tmpl", {
      "application_subnet" = var.application_addr,
      "jumphost_subnet"    = var.jumphost_addr,
      "database_subnet"    = var.database_addr
    })
  }
}

resource "vcd_vapp_vm" "application_utility_linux" {
  depends_on = [
    time_sleep.destroy_minute

  ]
  name             = var.application_utility_linux
  computer_name    = var.application_utility_linux
  vapp_name        = vcd_vapp.application_utility.name
  vapp_template_id = data.vcd_catalog_vapp_template.template_linux.id

  memory    = 4096
  cpus      = 2
  cpu_cores = 2

  override_template_disk {
    bus_type    = "paravirtual"
    size_in_mb  = "20480.0"
    bus_number  = 0
    unit_number = 0
    iops        = 2000
  }

  guest_properties = {
    "hostname" = var.application_utility_linux
    "meta-data" = base64encode(templatefile("cloudinit/metadata.tmpl", {
    }))
    "user-data" = base64encode(templatefile("cloudinit/userdata.tmpl", {
      "hostname"       = var.application_utility_linux
      "linux_user"     = var.linux_user
      "linux_password" = local.linux_password
    }))
  }

  network_dhcp_wait_seconds = 300
  network {
    name               = vcd_vapp_org_network.application_utility.org_network_name
    type               = "org"
    adapter_type       = "VMXNET3"
    ip_allocation_mode = "DHCP"
    is_primary         = true
  }

  customization {
    enabled = true
  }
}

#Jumphost VM details

resource "vcd_vapp_vm" "jumphost_win" {
  depends_on = [
    time_sleep.destroy_minute

  ]
  name             = var.jumphost_win
  computer_name    = var.jumphost_win
  vapp_name        = vcd_vapp.jumphost_app.name
  vapp_template_id = data.vcd_catalog_vapp_template.template_win.id

  memory    = 8192
  cpus      = 2
  cpu_cores = 2

  override_template_disk {
    bus_type    = "paravirtual"
    size_in_mb  = "102400.0"
    bus_number  = 0
    unit_number = 0
    iops        = 2000
  }

  network_dhcp_wait_seconds = 300
  network {
    name               = vcd_vapp_org_network.jumphost.org_network_name
    type               = "org"
    adapter_type       = "VMXNET3"
    ip_allocation_mode = "DHCP"
    is_primary         = true
  }

  customization {
    allow_local_admin_password          = true
    auto_generate_password              = false
    admin_password                      = var.win_password
    must_change_password_on_first_login = false
    enabled                             = true
    initscript = templatefile("cloudinit/runonce.tmpl", {
      "application_subnet" = var.application_addr,
      "jumphost_subnet"    = var.jumphost_addr,
      "database_subnet"    = var.database_addr
    })
  }
}

#Database VM details
resource "vcd_vapp_vm" "database_win" {

  depends_on = [
    time_sleep.destroy_minute

  ]
  name             = var.database_win
  computer_name    = var.database_win
  vapp_name        = vcd_vapp.database_app.name
  vapp_template_id = data.vcd_catalog_vapp_template.template_win.id

  memory    = 32768
  cpus      = 4
  cpu_cores = 4

  override_template_disk {
    bus_type    = "paravirtual"
    size_in_mb  = "102400.0"
    bus_number  = 0
    unit_number = 0
    iops        = 2000
  }

  network_dhcp_wait_seconds = 300
  network {
    name               = vcd_vapp_org_network.database.org_network_name
    type               = "org"
    adapter_type       = "VMXNET3"
    ip_allocation_mode = "DHCP"
    is_primary         = true
  }

  customization {
    allow_local_admin_password          = true
    auto_generate_password              = false
    admin_password                      = var.win_password
    must_change_password_on_first_login = false
    enabled                             = true
    initscript = templatefile("cloudinit/runonce.tmpl", {
      "application_subnet" = var.application_addr,
      "jumphost_subnet"    = var.jumphost_addr,
      "database_subnet"    = var.database_addr
    })
  }
}