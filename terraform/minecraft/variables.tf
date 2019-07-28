variable "region" {
  description = "Region in which to create the Minecraft droplet"
  default = "nyc3"
}

variable "domain" {
  description = "Domain for which to create a zone and records"
}

variable "ssh_fingerprints" {
  description = "SSH fingerprint with which the instance will be accessed"
}

variable "image" {
  description = "OS image to use for the droplet"
  default = "centos-7-x64"
}

variable "size" {
  description = "Size of the minecraft droplet"
  default = "s-1vcpu-1gb"
}

variable "backup_enabled" {
  description = "Whether to backups on the droplet"
  default = false
}
