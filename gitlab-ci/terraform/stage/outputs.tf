output "external_ip_address" {
  value = module.vpc.vpc_network_id
}

output "external_ip_address_kubernetes" {
  value = module.kubernetes.cluster_external_v4_endpoint
}
output "external_ip_postgresql" {
  value = module.postgresql.external_ip_postgresql
}
