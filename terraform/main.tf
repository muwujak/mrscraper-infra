# Proxmox provider configuration

provider "proxmox" {
  pm_api_url          = var.proxmox_api_url
  pm_api_token_id     = var.proxmox_token_id
  pm_api_token_secret = var.proxmox_token_secret
  pm_tls_insecure     = true
}

# Generate random passwords for each VM
resource "random_password" "kube_passwords" {
  for_each = toset([for i in range(var.kube_count) : "kube-${i + 1}"])
  
  length           = 16
  special          = true
  override_special = "!@#$%^&*()_+-="
}

# Create multiple kube VMs using for_each
resource "proxmox_vm_qemu" "kube_vms" {
  for_each = {
    for i in range(var.kube_count) : 
    "kube-${i + 1}" => {
      name = "kube-${i + 1}"
      cores = var.kube_cores
      memory = var.kube_memory
      vmid = "${var.vmid_prefix}${format("%02d", i + 1)}"
      ip     = "${var.ip_prefix}${1 + i}"  # e.g., 192.168.1.101, 192.168.1.102
    }
  }

  # VM configuration
  name        = each.value.name
  vmid        = each.value.vmid
  target_node = var.node_name
  clone       = var.template_name
  os_type     = "linux"
  cores       = each.value.cores
  sockets     = 1
  cpu         = "host"
  memory      = each.value.memory
  onboot      = true
  agent       = 1
  scsihw      = "virtio-scsi-pci"
  # Disk configuration
  disk {
    type    = "disk"
    storage = var.storage_pool
    size    = var.disk_size

    iothread = 1
  }

  # Network configuration
  network {
    model  = "virtio"
    bridge = var.network_bridge
  }

  # Cloud-Init configuration
  ciuser     = var.cloudinit_user
  cipassword = random_password.kube_passwords[each.key].result
  sshkeys    = var.ssh_public_key

  ipconfig0  = "ip=${each.value.ip}/${var.ip_subnet},gw=${var.ip_gateway}"

  # Lifecycle rules
  lifecycle {
    ignore_changes = [
      cipassword,
      network,
    ]
  }

  depends_on = [random_password.kube_passwords]
}
