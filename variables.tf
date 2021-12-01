variable "vault_token" {}

variable "vault_url" {}

variable "vms" {
  type = map(object({
    datacenter = string
    datastore = string
    cluster = string
    template = string
    network = string
    name = string
    folder = string
    cpu = string
    ram = string
    disk = string
    hostname = string
    domain = string
    ipv4 = string
    netmask = string
    gateway = string
    dns = string
    }))

  default = {
