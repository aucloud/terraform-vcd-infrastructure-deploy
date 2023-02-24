/*
	Copyright (C) 2023 Sovereign Cloud Australia Pty. Ltd.
	All rights reserved.

    outputs.tf
    
    Use outputs to define values you need to be able get access to. 
    Examples could include:
        - Server names
        - IP addresses
    Examples do not include:
        - passwords

    Access via calling terraform init followed by terraform output (where you have access to the backend)
*/

output "build_details" {
  value = {
    web = {
      description = "details of the web"
      id          = vcd_vapp_vm.application_web_win.name
      name        = vcd_vapp.application_web.name
      ip_address  = vcd_vapp_vm.application_web_win.network[0].ip
    }
    app = {
      description = "details of the app"
      id          = vcd_vapp_vm.application_apps_win.name
      name        = vcd_vapp.application_app.name
      ip_address  = vcd_vapp_vm.application_apps_win.network[0].ip
    }
    utility = {
      description = "details of the utility"
      id          = vcd_vapp_vm.application_utility_linux.name
      name        = vcd_vapp.application_utility.name
      ip_address  = vcd_vapp_vm.application_utility_linux.network[0].ip
    }
    database = {
      description = "details of the database"
      id          = vcd_vapp_vm.database_win.name
      name        = vcd_vapp.database_app.name
      ip_address  = vcd_vapp_vm.database_win.network[0].ip
    }
    jumphost = {
      description = "details of the jumphost"
      id          = vcd_vapp_vm.jumphost_win.name
      name        = vcd_vapp.jumphost_app.name
      ip_address  = vcd_vapp_vm.jumphost_win.network[0].ip
    }
  }
}