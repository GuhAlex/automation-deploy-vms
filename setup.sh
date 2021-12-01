#!/usr/bin/env bash

clear
echo "Setup terraform main variables"

keys=(
  datacenter
  datastore
  cluster
  network
  template
  name
  folder
  cpu
  ram
  disk
  hostname
  domain
  ipv4
  netmask
  gateway
  dns
)

cp variables.tf /tmp/variables_tmp.tf
cp variables.tf /tmp/
cp deploy_vm_vcenter/vsphere_virtual_machine.tf /tmp/vsphere_virtual_machine_tmp.tf

interador=1
read -p "Set number of VMs: " qtd
while [ $interador -le $qtd ]
do
  read -p "host-$interador: " name[$interador]
echo "    \""${name[$interador]}"\" = {
       datacenter=
       datastore=
       cluster=
       network=
       template=
       name=
       folder=
       cpu=
       ram=
       disk=
       hostname=
       domain=
       ipv4=
       netmask=
       gateway=
       dns=
    }" >> /tmp/variables.tf

inter=1
for i in "${keys[@]}"; do
  defining="Set the VMs parameters $i: "
  read -p "$defining" values
  sed -i "s/$i=/$i = \"$values\"/g" /tmp/variables.tf
  inter=$(expr $inter + 1)

  if [ $inter -eq 7 ]
  then
    read -p "Do you want to create a new VM folder??[yes/no]: " ask
  fi

  if [ "$ask" = "yes" ]
  then
    sed -i 's/#//g' deploy_vm_vcenter/vsphere_virtual_machine.tf
  fi

done

  interador=$(expr $interador + 1)
done

echo "   }
   }" >> /tmp/variables.tf

mv /tmp/variables.tf variables.tf
