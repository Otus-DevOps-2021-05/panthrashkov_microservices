output "cluster_external_v4_endpoint" {
  value = "${resource.yandex_kubernetes_cluster.k8s-stage.master.0.external_v4_endpoint}"
}

