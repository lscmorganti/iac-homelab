resource "local_file" "ansible_inventory" {
  content = templatefile("inventory.tmpl",
    {
      controlplanes = {
        index      = range(local.controlplanes.count)
        ip_address = proxmox_vm_qemu.controlplanes.*.default_ipv4_address
        user       = proxmox_vm_qemu.controlplanes.*.ciuser
        vm_name    = proxmox_vm_qemu.controlplanes.*.name
      }
      workers-heavy = {
        index      = range(local.workers-heavy.count)
        ip_address = proxmox_vm_qemu.workers-heavy.*.default_ipv4_address
        user       = proxmox_vm_qemu.workers-heavy.*.ciuser
        vm_name    = proxmox_vm_qemu.workers-heavy.*.name
      }
      workers-light = {
        index      = range(local.workers-light.count)
        ip_address = proxmox_vm_qemu.workers-light.*.default_ipv4_address
        user       = proxmox_vm_qemu.workers-light.*.ciuser
        vm_name    = proxmox_vm_qemu.workers-light.*.name
      }      
    }
  )
  filename        = "inventory.ini"
  file_permission = "0600"
}