output "wilrus_ip_address" {
  value = digitalocean_droplet.wilris_minecraft.ipv4_address
}

output "wilrus_fqdn" {
  value = digitalocean_record.wilris_hostname.fqdn
}
