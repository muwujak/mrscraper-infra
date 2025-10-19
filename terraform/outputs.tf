output "kube_vms" {
  description = "kube VM details"
  value = {
    for vm_name, vm in proxmox_vm_qemu.kube_vms : vm_name => {
      id       = vm.id
      name     = vm.name
      vmid     = vm.vmid
      ip       = "${vm.ipconfig0}"
      password = random_password.kube_passwords[vm_name].result
    }
  }
  sensitive = true
}

output "kube_names" {
  description = "List of kube VM names"
  value       = [for vm in proxmox_vm_qemu.kube_vms : vm.name]
}
