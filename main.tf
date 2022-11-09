# Define required providers
terraform {
required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.48.0"
    }
  }
}

# Configure the OpenStack Provider
provider "openstack" {}

resource "openstack_networking_router_v2" "aras-u08-router" {
  name                = "aras-u08-router"
  admin_state_up      = true
  external_network_id = "600b8501-78cb-4155-9c9f-23dfcba88828"
}


resource "openstack_networking_network_v2" "aras-u08-net" {
  name           = "aras-u08-net"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "aras-u08-subnet1" {
  name       = "aras-u08-subnet1"
  network_id = "${openstack_networking_network_v2.aras-u08-net.id}"
  cidr       = "192.168.199.0/24"
  ip_version = 4
  dns_nameservers= ["1.1.1.1"]
}

# Router insterface
resource "openstack_networking_router_interface_v2" "router_interface_1" {
  router_id = "${openstack_networking_router_v2.aras-u08-router.id}"
  subnet_id = "${openstack_networking_subnet_v2.aras-u08-subnet1.id}"
  depends_on = [openstack_networking_router_v2.aras-u08-router]
}

# Import keypair

# -ssh-keygen -f aras_terraform_keypair

resource "openstack_compute_keypair_v2" "aras_terraform_keypair" {
  name       = "aras_terraform_keypair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCxLrkHfOxgmvAudGgd34eF9nrofqBhRBryDFLtW56ufhYTN1rGxqBz3+d6wFzz+BamBY+qoKBbi3iNBBQUER3vUuaESiX0G3SSKeDMJivIY1d0gHgJkyMHzRtce0MzdE2mED3bpwo3Z0zqObtuzLnMw/1rAHpoIttjzKGYPaLMFAi8DyCEZaaGfef3pepTqA4JmnAEqcOmR2noxzPItvfBYoodgx8TQqcvZJhjoV9pwpQLMySgV7RhLEgIiIR8D+E9tB8U8pS04WRFiXZRcxuUaWHPHiLVfNj0wOiN0blH+plBg4MdZ+pNA91rReRWfNrUD4O66kK37Hiy+nGIekXbmJvLl78ClX4xsGKvQYr7l1uHnX/r4Xlo4e2oqbcFOF4OD0h+FGTfT292lqL5c55bUk+9i1fstPR8RqLNn3lZgZHFPNJ6kIXYHFN+M94jmw9onRaC15N6CZxsbgnOl8o1RnWWDUWfg03T5eimRzvWkKaqo0CEs/hF5GmwHaXZb48="
}

# security groups and rules

resource "openstack_networking_secgroup_v2" "aras_u08_secgroup_1" {
  name        = "aras_u08_secgroup_1"
  description = "Security group Caprover"
}

resource "openstack_networking_secgroup_rule_v2" "aras_u08_secgroup_rule_1_ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.aras_u08_secgroup_1.id}"
}

resource "openstack_networking_secgroup_rule_v2" "aras_u08_secgroup_rule_1_80" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.aras_u08_secgroup_1.id}"
}

resource "openstack_networking_secgroup_rule_v2" "aras_u08_secgroup_rule_1_443" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.aras_u08_secgroup_1.id}"
}

resource "openstack_networking_secgroup_rule_v2" "aras_u08_secgroup_rule_1_3000" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 3000
  port_range_max    = 3000
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.aras_u08_secgroup_1.id}"
}

# floating ips

resource "openstack_networking_floatingip_v2" "aras_u08_floatip_1" {
  pool = "elx-public1"
}

# Floating ips associations

resource "openstack_compute_floatingip_associate_v2" "fip_1" {
  floating_ip = "${openstack_networking_floatingip_v2.aras_u08_floatip_1.address}"
  instance_id = "${openstack_compute_instance_v2.aras-u08-server.id}"
}

# 1 cumpute instances Gitlab


resource "openstack_compute_instance_v2" "aras-u08-server" {
  name            = "aras_u08_server"
  image_name        = "ubuntu-20.04-server-latest"
  flavor_name       = "v1-c2-m4-d60"
  key_pair        = "aras_terraform_keypair"
  security_groups = ["aras_u08_secgroup_1"]

  depends_on = [openstack_networking_network_v2.aras-u08-net, openstack_networking_subnet_v2.aras-u08-subnet1]

  network {
    name = "aras-u08-net"
    fixed_ip_v4 = "192.168.199.4"
  }
}