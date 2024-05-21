output "k8s-node-pool-id-one" {
  value = oci_containerengine_node_pool.pool1.id
}

output "k8s-node-pool-id-two" {
  value = oci_containerengine_node_pool.pool2.id
}

output "k8s-cluster-id" {
  value = oci_containerengine_cluster.kj-test-cluster.id
}