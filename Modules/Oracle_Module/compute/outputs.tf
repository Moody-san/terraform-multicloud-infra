output "server_details" {
  description = "Per-instance facts (name, role booleans, public/private IP) consumed by the inventory and load balancer modules."
  value = {
    name                  = join("", [oci_core_instance.server.display_name])
    all_details           = join("", [oci_core_instance.server.display_name, " ansible_host=", oci_core_instance.server.public_ip == "" ? oci_core_instance.server.private_ip : oci_core_instance.server.public_ip, " ansible_user=ubuntu"])
    is_oracle_master      = contains(regexall(".*master$", oci_core_instance.server.display_name), oci_core_instance.server.display_name)
    is_oracle_worker      = contains(regexall(".*worker.*", oci_core_instance.server.display_name), oci_core_instance.server.display_name)
    is_oracle_db          = contains(regexall(".*db.*", oci_core_instance.server.display_name), oci_core_instance.server.display_name)
    is_oracle_extramaster = contains(regexall(".*master[1-9].*", oci_core_instance.server.display_name), oci_core_instance.server.display_name)
    is_oracle_bastion     = contains(regexall(".*bastion.*", oci_core_instance.server.display_name), oci_core_instance.server.display_name)
    public_ip             = oci_core_instance.server.public_ip
    private_ip            = oci_core_instance.server.private_ip
  }
}


output "backenddetails" {
  description = "IP/ID/name tuple used to register the instance in the OCI load balancer backend sets."
  value = {
    server_ip   = oci_core_instance.server.private_ip
    server_id   = oci_core_instance.server.id
    server_name = oci_core_instance.server.display_name
  }
}

output "output_ips" {
  description = "Instance name and its reachable (public if present, else private) IP surfaced at the root."
  value = {
    server_ip   = oci_core_instance.server.public_ip != "" ? oci_core_instance.server.public_ip : oci_core_instance.server.private_ip
    server_name = oci_core_instance.server.display_name
  }
}
