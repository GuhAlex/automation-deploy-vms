data "vault_generic_secret" "vcenter" {
  path = "services/vcenter"
}

provider "vault" {
  address         = var.vault_url
  skip_tls_verify = true
  token           = var.vault_token
 }

 provider "vsphere" {
   user           = data.vault_generic_secret.vcenter.data["username"]
   password       = data.vault_generic_secret.vcenter.data["password"]
   vsphere_server = data.vault_generic_secret.vcenter.data["url"]

   allow_unverified_ssl = true
 }

module "deploy_vm_vcenter" {
  source   = "./deploy_vm_vcenter"
  for_each = var.vms
  vsphere-datacenter = each.value["datacenter"]
  vm-datastore       = each.value["datastore"]
  vsphere-cluster    = each.value["cluster"]
  vm-network         = each.value["network"]
  vm-template        = each.value["template"]
  vm-name            = each.value["name"]
  vm-folder          = each.value["folder"]
  vm-cpu             = each.value["cpu"]
  vm-ram             = each.value["ram"]
  vm-disk-size       = each.value["disk"]
  vm-hostname        = each.value["hostname"]
  vm-domain          = each.value["domain"]
  vm-ipv4-address    = each.value["ipv4"]
  vm-ipv4-netmask    = each.value["netmask"]
  vm-ipv4-gateway    = each.value["gateway"]
  vm-dns             = each.value["dns"]
}
