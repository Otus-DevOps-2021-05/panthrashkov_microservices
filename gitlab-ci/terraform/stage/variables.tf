variable cloud_id {
  description = "Cloud"
}
variable folder_id {
  description = "Folder"
}
variable region_id {
  # Значение региона по умолчанию
  description = "region"
  default     = "ru-central1"
}
variable zone {
  description = "Zone"
  # Значение по умолчанию
  default = "ru-central1-a"
}
variable public_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}
variable service_account_key_file {
  description = "key .json"
}
variable cores {
  description = "VM cores"
  default     = 2
}
variable memory {
  description = "VM memory"
  default     = 4
}
variable disk {
  description = "Disk size"
  default     = 50
}
variable service_account_id {
  description = "Service account ID"
}
variable ssh_private_key_path {
  description = "ssh private key path"
}
