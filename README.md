#  Automation VMs Deploy

User-friendly automation for create VMs on vCenter

## Requirements

- Shell environment
- vCenter environment
- Vault enviroment with [KV Secret](https://www.vaultproject.io/docs/secrets/kv) of your vCenter credentials
- [Vault cli](https://www.vaultproject.io/docs/commands), VAULT_ADDR and VAULT_TOKEN set in your Shell
- Terraform >= v1.0.11

### Setup

- Cloning the repository

    ```
    git clone git@github.com:GuhAlex/automation-deploy-vms.git
    ```
- Set the path of your kv secret on data block of the **main.tf** file:

    ```
      data "vault_generic_secret" "vcenter" {
        path = "services/vcenter"
      }

    ```

- Set the Key of your KV sercret on block "**provider** **vsphere**" on **main.tf** file:

  ```
      provider "vsphere" {
        user           = data.vault_generic_secret.vcenter.data["username"]
        password       = data.vault_generic_secret.vcenter.data["password"]
        vsphere_server = data.vault_generic_secret.vcenter.data["url"]
        allow_unverified_ssl = true
      }
  ```
in this case, the keys of secret are **username**, **password** and **url**



- Run the **setup.sh** script, that initialize an interactive session to set the variables to terraform
  ```
   bash setup.sh
  ```

- After that, runnning the terraform command process to create VMs.
```
terraform init
```
```
terraform plan
```
```
terraform apply
```

- Last but not least, run the **clearup.sh** to set all files for the next deployment
```
bash clearup.sh
```
