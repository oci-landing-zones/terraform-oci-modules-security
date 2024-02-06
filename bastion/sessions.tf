resource "oci_bastion_session" "these" {
    for_each = var.sessions_configuration != null ? var.sessions_configuration["sessions"] : {}
    lifecycle {
    ## Check 1: Check if the public key is provided in default_ssh_public_key or ssh_public_key
    precondition {
      condition     = each.value.ssh_public_key != null || var.sessions_configuration.default_ssh_public_key != null
      error_message = "VALIDATION FAILURE in session \"${each.key}\": A path to the public key must be provided in default_ssh_public_key or ssh_public_key"
    }
     ## Check 2: Check if fqdn is used when the session type is PORT_FORWARDING
    precondition {
      condition     = length(regexall("^[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", each.value.target_resource)) > 0 ? each.value.session_type == "PORT_FORWARDING" : true
      error_message = "VALIDATION FAILURE in session \"${each.key}\": The FQDN can be used only when the session type is PORT_FORWARDING."
    }
    ## Check 3: Check if target_resource_id and target_user are used when the session type is MANAGED_SSH
    precondition {
      condition     = each.value.session_type == "MANAGED_SSH" ? length(regexall("^ocid1.*$", each.value.target_resource)) > 0 && each.value.target_user != null : true
      error_message = "VALIDATION FAILURE in session \"${each.key}\": The ocid of resource and target_user must be used when the session type is MANAGED_SSH."
    }
    ## Check 3: Check if session type is specified in default_session_type or session_type
    precondition {
      condition     = each.value.session_type != null || var.sessions_configuration.default_session_type != null
      error_message = "VALIDATION FAILURE in bastion \"${each.key}\": You must provide at least one CIDR block either in session_type or default_session_type."
    }
    }
    bastion_id = length(regexall("^ocid1.*$", each.value.bastion_id)) > 0 ? each.value.bastion_id : oci_bastion_bastion.these[each.value.bastion_id].id
    key_details {
        public_key_content = each.value.ssh_public_key != null ? file(each.value.ssh_public_key) : file(var.sessions_configuration.default_ssh_public_key)
    }
    target_resource_details {
        session_type = each.value.session_type != null ? each.value.session_type : var.sessions_configuration.default_session_type #MANAGED_SSH / PORT_FORWARDING/
        target_resource_fqdn = length(regexall("^[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", each.value.target_resource)) > 0 ? each.value.target_resource : null
        target_resource_id = length(regexall("^ocid1.*$", each.value.target_resource)) > 0 ? each.value.target_resource : var.instances_dependency != null ? var.instances_dependency[each.value.target_resource].id : null
        target_resource_operating_system_user_name = each.value.target_user
        target_resource_port = each.value.target_port
        target_resource_private_ip_address = length(regexall("^(\\d+\\.){3}\\d+$", each.value.target_resource)) > 0 ? each.value.target_resource : var.clusters_dependency != null ? var.clusters_dependency[each.value.target_resource].endpoints.private_endpoint : null
    }
    display_name = each.value.session_name
    session_ttl_in_seconds = each.value.session_ttl_in_seconds
}