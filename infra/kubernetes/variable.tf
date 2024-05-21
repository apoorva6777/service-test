variable "compartment_id" {
  description = "Display name used for compartment"
  type        = string
  default     = "ocid1.compartment.oc1..aaaaaaaafujaxb5oanlmpe4nuyzxjircz6cfm75pqp5b2cjqbri6de4qy7gq"
}

##################################################
# kubernetes cluster 
##################################################

variable "cluster_cluster_pod_network_options_cni_type" {
  description = "The Container Networking Interface (CNI) type for the Kubernetes pod network options in the cluster configuration."
  type        = string
  default     = "OCI_VCN_IP_NATIVE"
}

variable "cluster_endpoint_config_is_public_ip_enabled" {
  description = "A boolean flag indicating whether the Kubernetes API server endpoint is exposed with a public IP address. If set to true, the API server endpoint is exposed publicly; if false, it is private."
  type        = bool
  default     = true
}

variable "cluster_image_policy_config_is_policy_enabled" {
  description = "A boolean flag indicating whether the image policy configuration is enabled for the cluster. If set to true, the image policy configuration is enabled; if false, it is disabled."
  type        = bool
  default     = false
}

variable "cluster_kubernetes_version" {
  description = "The version of Kubernetes to be used for the cluster."
  type        = string
  default     = "v1.27.2"
}

variable "cluster_name" {
  description = "A user-defined name for the Kubernetes cluster."
  type        = string
  default     = "kj-cluster"
}

variable "cluster_options_add_ons_is_kubernetes_dashboard_enabled" {
  description = "A boolean flag indicating whether the Kubernetes Dashboard add-on is enabled for the cluster. If set to true, the Kubernetes Dashboard is enabled; if false, it is disabled."
  type        = bool
  default     = false
}

variable "cluster_options_add_ons_is_tiller_enabled" {
  description = "A boolean flag indicating whether the Helm Tiller add-on is enabled for the cluster. If set to true, Helm Tiller is enabled; if false, it is disabled."
  type        = bool
  default     = false
}

variable "cluster_options_admission_controller_options_is_pod_security_policy_enabled" {
  description = "A boolean flag indicating whether the PodSecurityPolicy admission controller is enabled for the cluster. If set to true, PodSecurityPolicy is enabled; if false, it is disabled."
  type        = bool
  default     = false
}

variable "cluster_options_kubernetes_network_config_pods_cidr" {
  description = "The CIDR block for Kubernetes pod networking configuration in the cluster."
  type        = string
  default     = "10.244.0.0/16"
}

variable "cluster_options_kubernetes_network_config_services_cidr" {
  description = "The CIDR block for Kubernetes service networking configuration in the cluster."
  type        = string
  default     = "10.96.0.0/16"
}

variable "nsg_ids" {
  description = "List of Network Security Group (NSG) IDs"
  type        = list(string)
  default     = []
}
variable "kms_key_id" {
  description = "Key Management Service (KMS) Key ID"
  type        = string
  default     = null
}
variable "cluster_type" {
  description = "Type of the cluster"
  type        = string
  default     = "BASIC_CLUSTER"
}



#############################################
# node pool
#############################################
variable "node_pool_initial_node_labels_key" {
  description = "The key for the initial node labels in the Kubernetes node pool configuration."
  type        = string
  default     = "name"
}

variable "node_pool_initial_node_labels_value" {
  description = "The value for the initial node labels in the Kubernetes node pool configuration."
  type        = string
  default     = "kj-cluster"
}

variable "node_pool_kubernetes_version" {
  description = "The version of Kubernetes to be used for the node pool."
  type        = string
  default     = "v1.27.2"
}

variable "node_pool_name_one" {
  description = "A user-defined name for the Kubernetes node pool."
  type        = string
  default     = "pool1"
}

variable "node_pool_name_two" {
  description = "A user-defined name for the Kubernetes node pool."
  type        = string
  default     = "pool2"
}


variable "node_pool_node_config_details_is_pv_encryption_in_transit_enabled" {
  description = "A boolean flag indicating whether persistent volume (PV) encryption in transit is enabled for the node pool."
  type        = bool
  default     = false
}

variable "node_pool_node_config_details_node_pool_pod_network_option_details_cni_type" {
  description = "The Container Networking Interface (CNI) type for the pod network options in the Kubernetes node pool configuration."
  type        = string
  default     = "OCI_VCN_IP_NATIVE"
}

variable "node_pool_node_config_details_node_pool_pod_network_option_details_max_pods_per_node" {
  description = "The maximum number of pods per node for the pod network options in the Kubernetes node pool configuration."
  type        = string
  default     = "93"
}

variable "image_policy_config_kms_key_id" {
  description = "The OCID of the Key Management Service (KMS) key to be used for signing the image policy."
  type        = string
  default     = null
}


variable "node_pool_node_config_details_placement_configs_preemptible_node_config_preemption_action_is_preserve_boot_volume" {
  description = "A boolean flag indicating whether to preserve the boot volume during preemption for preemptible nodes in the Kubernetes node pool."
  type        = bool
  default     = false
}

variable "node_pool_node_config_details_size" {
  description = "The number of nodes in the Kubernetes node pool."
  type        = string
  default     = "2"
}

variable "node_pool_node_eviction_node_pool_settings_eviction_grace_duration" {
  description = "The duration for eviction grace period in the Kubernetes node pool."
  type        = string
  default     = "PT1H"
}

variable "node_pool_node_eviction_node_pool_settings_is_force_delete_after_grace_duration" {
  description = "A boolean flag indicating whether to force delete nodes after the eviction grace period in the Kubernetes node pool."
  type        = string
  default     = true
}

variable "node_pool_node_shape" {
  description = "The shape of the nodes in the Kubernetes node pool."
  type        = string
  default     = "VM.Standard.A1.Flex"
}

variable "node_pool_node_shape_config_memory_in_gbs_one" {
  description = "The amount of memory (in gigabytes) for each node in the Kubernetes node pool 1"
  type        = string
  default     = "12"
}

variable "node_pool_node_shape_config_memory_in_gbs_two" {
  description = "The amount of memory (in gigabytes) for each node in the Kubernetes node pool 2"
  type        = string
  default     = "8"
}

variable "node_pool_node_shape_config_ocpus_one" {
  description = "The number of virtual CPUs (OCPUs) for each node in the Kubernetes node pool 1"
  type        = string
  default     = "4"
}
variable "node_pool_node_shape_config_ocpus_two" {
  description = "The number of virtual CPUs (OCPUs) for each node in the Kubernetes node pool 2"
  type        = string
  default     = "4"
}

variable "node_pool_node_source_details_image_id" {
  description = "The OCID (Oracle Cloud Identifier) of the image used as the source for creating nodes in the Kubernetes node pool."
  type        = string
  default     = "ocid1.image.oc1.iad.aaaaaaaamfhvgmej5jiwcqc3xprachdoc5yhwn4zwub5yok67d6m47vry6na"
}

variable "node_pool_node_source_details_source_type" {
  description = "The source type for creating nodes in the Kubernetes node pool. Set to 'IMAGE' for using a custom image as the source."
  type        = string
  default     = "IMAGE"
}

variable "node_pool_node_pool_cycling_details_is_node_cycling_enabled" {
  description = "A boolean flag indicating whether node cycling is enabled for the Kubernetes node pool."
  type        = bool
  default     = false
}

variable "node_pool_node_pool_cycling_details_maximum_surge" {
  description = "The maximum number of additional nodes that can be added to the Kubernetes node pool during node cycling."
  type        = string
  default     = "1"
}

variable "node_pool_node_pool_cycling_details_maximum_unavailable" {
  description = "The maximum number of nodes that can be concurrently unavailable during node cycling in the Kubernetes node pool."
  type        = string
  default     = "0"
}

variable "node_pool_quantity_per_subnet" {
  description = "The number of nodes to create per subnet in the Kubernetes node pool. If null, the default behavior is used."
  type        = string
  default     = null
}

variable "node_pool_ssh_public_key" {
  description = "The SSH public key to be included on the nodes in the Kubernetes node pool. If null, the default behavior is used."
  type        = string
  default     = null
}

variable "node_pool_subnet_ids" {
  description = "A list of subnet OCIDs (Oracle Cloud Identifiers) where the nodes in the Kubernetes node pool will be created."
  type        = list(string)
  default     = null
}

variable "kms_key_id_node_pool_one" {
  description = "Key Management Service (KMS) Key ID for the node pool 1"
  type        = string
  default     = null
}

variable "kms_key_id_node_pool_two" {
  description = "Key Management Service (KMS) Key ID for the node pool 2"
  type        = string
  default     = null
}


variable "node_pool_nsg_ids_one" {
  description = "List of Network Security Group (NSG) IDs for the node pool 1"
  type        = list(string)
  default     = []
}

variable "node_pool_nsg_ids_two" {
  description = "List of Network Security Group (NSG) IDs for the node pool 2"
  type        = list(string)
  default     = []
}

variable "capacity_reservation_id_one" {
  description = "ID of the capacity reservation"
  type        = string
  default     = null
}

variable "capacity_reservation_id_two" {
  description = "ID of the capacity reservation"
  type        = string
  default     = null
}

variable "boot_volume_size_in_gbs_one" {
  description = "Size of the boot volume in gigabytes"
  type        = number
  default     = null
}

variable "boot_volume_size_in_gbs_two" {
  description = "Size of the boot volume in gigabytes"
  type        = number
  default     = null
}

variable "node_pool_size_one" {
  description = "Size of the node pool 1"
  type        = string
  default     = "1"
}

variable "node_pool_size_two" {
  description = "Size of the node pool 2"
  type        = string
  default     = "1"
}

variable "node_metadata_one" {
  description = "Node metadata for the node pool 1"
  type        = map(string)
  default     = {}
}

variable "node_metadata_two" {
  description = "Node metadata for the node pool 2"
  type        = map(string)
  default     = {}
}
variable "fault_domains_one" {
  description = "List of fault domains"
  type        = list(string)
  default     = []
}

variable "fault_domains_two" {
  description = "List of fault domains"
  type        = list(string)
  default     = []
}
variable "pod_nsg_ids_one" {
  description = "List of pod network security group IDs for pool 1"
  type        = list(string)
  default     = []
}

variable "pod_nsg_ids_two" {
  description = "List of pod network security group IDs for pool 2"
  type        = list(string)
  default     = []
}

variable "preemption_action_type" {
  description = "Type of Action to perform on preemptible instances"
  type        = string
  default     = "TERMINATE"
}



##################################################
# policy variables
##################################################

variable "policy_description" {
  description = "Description for the policy. Provide a meaningful description to explain the purpose or intent of this policy."
  type        = string
  default     = "Policy for Kubernetes Cluster Autoscaler as a Cluster Standalone Program"
}

variable "policy_name" {
  description = "Name for the policy. Specify a unique and identifiable name for the policy."
  type        = string
  default     = "kj-oke-policy"
}

variable "dynamic_group" {
    description=""
    default="autoscaler-dynamic-group"
    type=string
}

variable "compartment_name"{
    description=""
    default="Transility-oci"
    type=string
}
variable "version_date" {
  description = "Date of the version"
  type        = string
  default     = null
}



##################################################
# dynamic blocks
##################################################
variable "configure_key_details" {
  description = "Set this variable to true if you want to configure key details. When true, the necessary key details, such as the Key Management Service (KMS) key OCID, should be provided."
  type        = bool
  default     = false
}

