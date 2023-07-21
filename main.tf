terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.48.0"
    }
  }
}

provider "openstack" {
  use_octavia = true
}


# -- Keypairs --

resource "openstack_compute_keypair_v2" "caprov-keypair" {
  name = "caprov-keypair"
}

resource "local_file" "app_cert" {
    content = "${openstack_compute_keypair_v2.caprov-keypair.private_key}"
    filename = "./caprov_keypair_rsa"
} 


# -- Networking --

resource "openstack_networking_router_v2" "cap_router" {
  name                = "cap_router"
  admin_state_up      = true
  external_network_id = "600b8501-78cb-4155-9c9f-23dfcba88828"
}

resource "openstack_networking_network_v2" "capnet" {
  name           = "capnet"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "cap_subnet" {
  name = "capnet_subnet"
  network_id = "${openstack_networking_network_v2.capnet.id}"
  cidr       = "192.168.1.0/24"
  ip_version = 4
  dns_nameservers = ["1.1.1.1"]
}

resource "openstack_networking_router_interface_v2" "router_interface_1" {
  router_id = "${openstack_networking_router_v2.cap_router.id}"
  subnet_id = "${openstack_networking_subnet_v2.cap_subnet.id}"
}


# -- Floating IP;s

resource "openstack_networking_floatingip_v2" "caprover-server-floating_ip" {
  pool = "elx-public1"
}

resource "openstack_networking_floatingip_v2" "caprover-worker-floating_ip" {
  pool = "elx-public1"
}

resource "openstack_compute_floatingip_associate_v2" "cap_server_fip" {
  floating_ip = "${openstack_networking_floatingip_v2.caprover-server-floating_ip.address}"
  instance_id = "${openstack_compute_instance_v2.caprover-server.id}"
}

resource "openstack_compute_floatingip_associate_v2" "cap_worker_fip" {
  floating_ip = "${openstack_networking_floatingip_v2.caprover-worker-floating_ip.address}"
  instance_id = "${openstack_compute_instance_v2.caprover-worker.id}"
}

# -- Security group

resource "openstack_networking_secgroup_v2" "caprov-sec-group" {
  name = "caprov-sec-group"
  description = "Security group for caprov-server"  
}

# -- Security group rules --

resource "openstack_networking_secgroup_rule_v2" "caprov-sec-ssh" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 22
  port_range_max = 22
  remote_ip_prefix = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.caprov-sec-group.id}"
}

resource "openstack_networking_secgroup_rule_v2" "caprov-sec-http" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.caprov-sec-group.id}"
}

resource "openstack_networking_secgroup_rule_v2" "caprov-sec-https" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.caprov-sec-group.id}"
}

resource "openstack_networking_secgroup_rule_v2" "caprov-sec-start_port" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 3000
  port_range_max    = 3000
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.caprov-sec-group.id}"
}

resource "openstack_networking_secgroup_rule_v2" "caprov-sec-xtree" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 996
  port_range_max    = 996
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.caprov-sec-group.id}"
}

resource "openstack_networking_secgroup_rule_v2" "caprov-sec-docker-swarm" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 7946
  port_range_max    = 7946
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.caprov-sec-group.id}"
}

resource "openstack_networking_secgroup_rule_v2" "caprov-sec-vxlan" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 4789
  port_range_max    = 4789
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.caprov-sec-group.id}"
}

resource "openstack_networking_secgroup_rule_v2" "caprov-sec-docker-swarm-2" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 2377
  port_range_max    = 2377
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.caprov-sec-group.id}"
}

resource "openstack_networking_secgroup_rule_v2" "caprov-sec-docker-swarm-2-udp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 2377
  port_range_max    = 2377
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.caprov-sec-group.id}"
}

resource "openstack_networking_secgroup_rule_v2" "caprov-sec-vxlan-udp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 4789
  port_range_max    = 4789
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.caprov-sec-group.id}"
}

resource "openstack_networking_secgroup_rule_v2" "caprov-sec-docker-swarm-udp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 7946
  port_range_max    = 7946
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.caprov-sec-group.id}"
}

# -- Caprover compute instances --

resource "openstack_compute_instance_v2" "caprover-server" {
  name = "caproverserver"
  flavor_name = "v1-c4-m8-d120"
  image_name = "ubuntu-22.04-server-latest"
  key_pair = "caprov-keypair"
  security_groups = ["caprov-sec-group"]

  network {
    name = "capnet"
    fixed_ip_v4 = "192.168.1.101"
  }

  depends_on = [
    openstack_networking_network_v2.capnet,
    openstack_networking_subnet_v2.cap_subnet
  ]
}

resource "openstack_compute_instance_v2" "caprover-worker" {
  name = "caproverworker"
  flavor_name = "v1-c4-m8-d120"
  image_name = "ubuntu-22.04-server-latest"
  key_pair = "caprov-keypair"
  security_groups = ["caprov-sec-group"]

  network {
    name = "capnet"
    fixed_ip_v4 = "192.168.1.102"
  }

  depends_on = [
    openstack_networking_network_v2.capnet,
    openstack_networking_subnet_v2.cap_subnet
  ]
}









