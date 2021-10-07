provider "yandex" {
  version                  = "0.35"
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

resource "yandex_vpc_network" "app-network" {
  name = "kubernetes-network"
}

resource "yandex_vpc_subnet" "app-subnet" {
  name           = "kubernetes-subnet"
  zone           = var.zone
  network_id     = "${yandex_vpc_network.app-network.id}"
  v4_cidr_blocks = ["192.168.10.0/28"]
}

resource "yandex_kubernetes_cluster" "k8s-stage" {
  name       = "k8s-stage"
  network_id     = "${yandex_vpc_network.app-network.id}"

  master {
    version = "1.19"

    zonal {
      zone      = var.zone
      subnet_id = "${yandex_vpc_subnet.app-subnet.id}"
    }

    public_ip = true
  }

  service_account_id      = var.service_account_id
  node_service_account_id = var.service_account_id

  release_channel = "RAPID"
  network_policy_provider = "CALICO"
}

resource "yandex_kubernetes_node_group" "k8s-node" {
  cluster_id = yandex_kubernetes_cluster.k8s-stage.id
  version    = "1.19"
  name = "k8s-node"

  instance_template {
      nat       = true

    resources {
      cores  = var.cores
      memory = var.memory
    }

    boot_disk {
      type = "network-ssd"
      size = var.disk
    }

    metadata = {
      ssh-keys = "ubuntu:${file(var.public_key_path)}"
    }
  }

  scale_policy {
    fixed_scale {
      size = var.node_count
    }
  }
}

