provider "oci" {
  config_file_profile = "DEFAULT"
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

resource "oci_identity_policy" "policy_for_autoscaler" {
  compartment_id = var.compartment_id
  description    = var.policy_description
  name           = var.policy_name
  statements     = ["Allow dynamic-group ${var.dynamic_group} to manage cluster-node-pools in compartment ${var.compartment_name}",
    "Allow dynamic-group ${var.dynamic_group} to manage instance-family in compartment ${var.compartment_name}",
    "Allow dynamic-group ${var.dynamic_group} to use subnets in compartment ${var.compartment_name}",
    "Allow dynamic-group ${var.dynamic_group} to read virtual-network-family in compartment ${var.compartment_name}",
    "Allow dynamic-group ${var.dynamic_group} to use vnics in compartment ${var.compartment_name}",
    "Allow dynamic-group ${var.dynamic_group} to inspect compartments in compartment ${var.compartment_name}"
  ]
  freeform_tags  = {}
  version_date   = var.version_date
  defined_tags   = {}
}

resource "oci_containerengine_cluster" "kj-test-cluster" {
  cluster_pod_network_options {
    cni_type = var.cluster_cluster_pod_network_options_cni_type
  }
  compartment_id = var.compartment_id
  defined_tags   = {}
  endpoint_config {
    is_public_ip_enabled = var.cluster_endpoint_config_is_public_ip_enabled
    nsg_ids              = var.nsg_ids
    subnet_id            = "ocid1.subnet.oc1.iad.aaaaaaaartvhfh4ngx3tqlsqxrl3i5pzt6bayxahhr2sjckt4mw23n7qeriq"
  }
  freeform_tags = {}
  image_policy_config {
    is_policy_enabled = var.cluster_image_policy_config_is_policy_enabled

    dynamic "key_details" {
      for_each = var.configure_key_details ? [1] : []
      content {
        kms_key_id = var.image_policy_config_kms_key_id
      }
    }
  }
  kms_key_id         = var.kms_key_id
  kubernetes_version = var.cluster_kubernetes_version
  name               = var.cluster_name
  options {
    add_ons {
      is_kubernetes_dashboard_enabled = var.cluster_options_add_ons_is_kubernetes_dashboard_enabled
      is_tiller_enabled               = var.cluster_options_add_ons_is_tiller_enabled
    }
    admission_controller_options {
      is_pod_security_policy_enabled = var.cluster_options_admission_controller_options_is_pod_security_policy_enabled
    }
    kubernetes_network_config {
      pods_cidr     = var.cluster_options_kubernetes_network_config_pods_cidr
      services_cidr = var.cluster_options_kubernetes_network_config_services_cidr
    }
    persistent_volume_config {
      defined_tags = {}
      freeform_tags = {}
    }
    service_lb_config {
      defined_tags = {}
      freeform_tags = {}
    }
    service_lb_subnet_ids = [
      "ocid1.subnet.oc1.iad.aaaaaaaaoucw6xh3euio34jtlmjumvilsvwiewx3bidsouan3xujzf2uv74a",
    ]
  }
  type   = var.cluster_type
  vcn_id = "ocid1.vcn.oc1.iad.amaaaaaahxy4fkaay62vyfsl2ugz3s5c7uu5l77akxxy3iw6joephlbyl7ja"
}

resource "oci_containerengine_node_pool" "pool1" {
  cluster_id     = oci_containerengine_cluster.kj-test-cluster.id
  compartment_id = var.compartment_id
  defined_tags = {}
  freeform_tags = {}
  initial_node_labels {
    key   = var.node_pool_initial_node_labels_key
    value = var.node_pool_initial_node_labels_value
  }
  kubernetes_version = var.node_pool_kubernetes_version
  name               = var.node_pool_name_one
  node_config_details {

    is_pv_encryption_in_transit_enabled = var.node_pool_node_config_details_is_pv_encryption_in_transit_enabled
    kms_key_id                          = var.kms_key_id_node_pool_one
    defined_tags                        = {}
    freeform_tags                       = {}

    node_pool_pod_network_option_details {
      cni_type          = var.node_pool_node_config_details_node_pool_pod_network_option_details_cni_type
      max_pods_per_node = var.node_pool_node_config_details_node_pool_pod_network_option_details_max_pods_per_node
      pod_nsg_ids = var.pod_nsg_ids_one
      pod_subnet_ids = [
        "ocid1.subnet.oc1.iad.aaaaaaaazdvwuroqmwdia6u4jekw3katinftvc53kxs3ibkw6dhnrsuugl4a",
      ]
    }
    nsg_ids = var.node_pool_nsg_ids_one
    placement_configs {
      availability_domain     = data.oci_identity_availability_domains.ads.availability_domains[0].name
      capacity_reservation_id = var.capacity_reservation_id_one
      fault_domains = var.fault_domains_one

      # preemptible_node_config {
      #   #Required
      #   preemption_action {
      #     #Required
      #     type = "TERMINATE"

      #     #Optional
      #     is_preserve_boot_volume = var.node_pool_node_config_details_placement_configs_preemptible_node_config_preemption_action_is_preserve_boot_volume
      #   }
      # }
      subnet_id = "ocid1.subnet.oc1.iad.aaaaaaaazdvwuroqmwdia6u4jekw3katinftvc53kxs3ibkw6dhnrsuugl4a"

    }

    size = var.node_pool_size_one
  }
  node_eviction_node_pool_settings {
    eviction_grace_duration              = var.node_pool_node_eviction_node_pool_settings_eviction_grace_duration
    is_force_delete_after_grace_duration = var.node_pool_node_eviction_node_pool_settings_is_force_delete_after_grace_duration
  }
  node_metadata = var.node_metadata_one
  node_shape    = var.node_pool_node_shape
  node_shape_config {
    memory_in_gbs = var.node_pool_node_shape_config_memory_in_gbs_one
    ocpus         = var.node_pool_node_shape_config_ocpus_one
  }
  node_source_details {
    boot_volume_size_in_gbs = var.boot_volume_size_in_gbs_one
    image_id                = var.node_pool_node_source_details_image_id
    source_type             = var.node_pool_node_source_details_source_type
  }
  node_pool_cycling_details {

    #Optional
    is_node_cycling_enabled = var.node_pool_node_pool_cycling_details_is_node_cycling_enabled
    maximum_surge           = var.node_pool_node_pool_cycling_details_maximum_surge
    maximum_unavailable     = var.node_pool_node_pool_cycling_details_maximum_unavailable
  }
  quantity_per_subnet = var.node_pool_quantity_per_subnet
  ssh_public_key      = var.node_pool_ssh_public_key
  subnet_ids          = var.node_pool_subnet_ids
  lifecycle {
    ignore_changes = [
      node_config_details[0].size
    ]
  }
}

resource "oci_containerengine_node_pool" "pool2" {
  cluster_id     = oci_containerengine_cluster.kj-test-cluster.id
  compartment_id = var.compartment_id
  defined_tags = {}
  freeform_tags = {}
  initial_node_labels {
    key   = var.node_pool_initial_node_labels_key
    value = var.node_pool_initial_node_labels_value
  }
  kubernetes_version = var.node_pool_kubernetes_version
  name               = var.node_pool_name_two
  node_config_details {

    is_pv_encryption_in_transit_enabled = var.node_pool_node_config_details_is_pv_encryption_in_transit_enabled
    kms_key_id                          = var.kms_key_id_node_pool_two
    defined_tags                        = {}
    freeform_tags                       = {}

    node_pool_pod_network_option_details {
      cni_type          = var.node_pool_node_config_details_node_pool_pod_network_option_details_cni_type
      max_pods_per_node = var.node_pool_node_config_details_node_pool_pod_network_option_details_max_pods_per_node
      pod_nsg_ids = var.pod_nsg_ids_two
      pod_subnet_ids = [
        "ocid1.subnet.oc1.iad.aaaaaaaazdvwuroqmwdia6u4jekw3katinftvc53kxs3ibkw6dhnrsuugl4a",
      ]
    }
    nsg_ids = var.node_pool_nsg_ids_two
    placement_configs {
      availability_domain     = data.oci_identity_availability_domains.ads.availability_domains[0].name
      capacity_reservation_id = var.capacity_reservation_id_two
      fault_domains = var.fault_domains_two

      preemptible_node_config {
        #Required
        preemption_action {
          #Required
          type =  var.preemption_action_type

          #Optional
          is_preserve_boot_volume = var.node_pool_node_config_details_placement_configs_preemptible_node_config_preemption_action_is_preserve_boot_volume
        }
      }
      subnet_id = "ocid1.subnet.oc1.iad.aaaaaaaazdvwuroqmwdia6u4jekw3katinftvc53kxs3ibkw6dhnrsuugl4a"

    }

    size = var.node_pool_size_two
  }
  node_eviction_node_pool_settings {
    eviction_grace_duration              = var.node_pool_node_eviction_node_pool_settings_eviction_grace_duration
    is_force_delete_after_grace_duration = var.node_pool_node_eviction_node_pool_settings_is_force_delete_after_grace_duration
  }
  node_metadata = var.node_metadata_two
  node_shape    = var.node_pool_node_shape
  node_shape_config {
    memory_in_gbs = var.node_pool_node_shape_config_memory_in_gbs_two
    ocpus         = var.node_pool_node_shape_config_ocpus_two
  }
  node_source_details {
    boot_volume_size_in_gbs = var.boot_volume_size_in_gbs_two
    image_id                = var.node_pool_node_source_details_image_id
    source_type             = var.node_pool_node_source_details_source_type
  }
  node_pool_cycling_details {

    #Optional
    is_node_cycling_enabled = var.node_pool_node_pool_cycling_details_is_node_cycling_enabled
    maximum_surge           = var.node_pool_node_pool_cycling_details_maximum_surge
    maximum_unavailable     = var.node_pool_node_pool_cycling_details_maximum_unavailable
  }
  quantity_per_subnet = var.node_pool_quantity_per_subnet
  ssh_public_key      = var.node_pool_ssh_public_key
  subnet_ids          = var.node_pool_subnet_ids
  lifecycle {
    ignore_changes = [
      node_config_details[0].size
    ]
  }
}

