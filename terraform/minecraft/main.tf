locals {
  do_token = chomp(file("~/.do-token"))
}

provider "digitalocean" {
  token = local.do_token
}

resource "digitalocean_domain" "domain" {
  name = var.domain
}

resource "digitalocean_record" "wilris_hostname" {
  domain = var.domain
  type = "A"
  name = "wilris"
  value = digitalocean_droplet.wilris_minecraft.ipv4_address
}

resource "digitalocean_droplet" "wilris_minecraft" {
  name = "minecraft-wilris"
  image = var.image
  region = var.region
  size = var.size
  ssh_keys = var.ssh_fingerprints
  backups = var.backup_enabled

  provisioner "local-exec" {
    command = "sleep 45; ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -u root --private-key ~/.ssh/id_rsa -i \"${digitalocean_droplet.wilris_minecraft.ipv4_address},\" provisioner/ansible-playbook.yml"
  }
}

resource "digitalocean_firewall" "minecraft" {
  name = "minecraft"
  droplet_ids = [ digitalocean_droplet.wilris_minecraft.id ]

  inbound_rule {
    protocol = "tcp"
    port_range = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol = "tcp"
    port_range = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol = "tcp"
    port_range = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol = "tcp"
    port_range = "25565"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol = "udp"
    port_range = "25565"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol = "tcp"
    port_range = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol = "udp"
    port_range = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}
