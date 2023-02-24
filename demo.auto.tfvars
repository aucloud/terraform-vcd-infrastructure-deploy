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
   limitations under the License. */

#Please create the catalog and ensure template is available before attempting to build.


org          = "" # Please add the org value here.
vdc          = "" # Please add the vdc value here.
edge_gateway = "" # Please add the edge gateway value here
url          = "" # Please add api url value here.

# general network
dns1 = "" # Please provide dns e.g. 8.8.8.8
dns2 = "" # Please provide dns e.g. 1.1.1.1

# application details
application_public_ip     = "" # Please add an ip from the edge gateway ip allocation.
application_public_vip    = "" # Please add an ip from the edge gateway ip allocation.
application_addr          = "" # Please provide an internal ip subnet here.
application_web_win       = "" # Specify a name for the server e.g. database
application_apps_win      = "" # Specify a name for the server e.g. apps
application_utility_linux = "" # Specify a name for the server e.g. utility

# jumphost details
jumphost_public_ip = "" # Retrieve the public ip's from the portal - IP Management/IP Allocations
jumphost_addr      = "" # Assign subnet e.g. 10.100.2
jumphost_win       = "" # Specify a name for the server e.g. jumphost

# Database details
database_addr = "" # Assign subnet e.g. 10.100.2
database_win  = "" # Specify a name for the server e.g. database

#Catalog details
catalog_name   = "" # Ensure catalog exists e.g. demo
template_linux = "" # Ensure template exists in catalog created e.g. Ubuntu 20.04 Server (demo)
template_win   = "" # Ensure template exists in catalog created e.g. Win2K19-Small

vcd_max_retry_timeout    = "240"
vcd_allow_unverified_ssl = "false"