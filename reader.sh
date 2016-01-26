#!/bin/bash

echo "Please enter the number of VMs you would like to create:"
read vm_amount

echo "Please enter the prefix name for your VMs:"
read vm_prefix

printf "\n"

function vm_name_creator {

for i in $(seq 1 $vm_amount); do
	echo $vm_prefix$i
done

}

vm_name_creator | tee list_of_vms.txt
