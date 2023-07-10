resource "oci_core_vcn" "vcn" {
  compartment_id = var.compartment_ocid
  cidr_block     = var.cidr_ip_block
  display_name   = var.vcn_name
}

resource "oci_core_internet_gateway" "igw" {
  compartment_id = var.compartment_ocid
  display_name   = var.internet_gateway_name
  vcn_id         = oci_core_vcn.vcn.id
}

resource "oci_core_route_table" "prt" {
  compartment_id = var.compartment_ocid
  display_name   = var.route_table_name
  vcn_id         = oci_core_vcn.vcn.id

  route_rules {
    destination       = var.destination_ip
    network_entity_id = oci_core_internet_gateway.igw.id
  }
}

resource "oci_core_subnet" "subnet" {
  availability_domain = ""
  compartment_id      = var.compartment_ocid
  display_name        = var.subnet_name
  vcn_id              = oci_core_vcn.vcn.id
  cidr_block          = var.subnet_ip
  route_table_id      = oci_core_route_table.prt.id
  security_list_ids   = [oci_core_security_list.securitylist.id]
}

resource "oci_core_security_list" "securitylist" {
  for_each = toset(var.ingress_ports)

  display_name   = var.security_list_name
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn.id

  egress_security_rules {
    protocol    = var.egress_rules.protocol
    destination = var.egress_rules.all
  }

  ingress_security_rules {
    protocol = var.tcp_ingress_rules.protocol
    source   = var.tcp_ingress_rules.source
    tcp_options {
      min = each.value
      max = each.value
    }
  }


  ingress_security_rules {
    protocol = var.icmp_ingress_rules.protocol # ICMP
    source   = var.icmp_ingress_rules.source
    icmp_options {
      type = var.icmp_ingress_rules.type
    }
  }
}