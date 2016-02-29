#!/bin/bash

echo "Please enter KVM virtual machine prefix:"
echo "Ex: vm-server, web, lemon-worker, etc..."
read VM_prefix

echo "Please enter KVM virtual machine suffix starting range:"
echo "Ex: 1, 2, 004, etc..."
read VM_suffix_starting

echo "Please enter KVM virtual machine suffix ending range:"
echo "Ex: 6, 9, 099, etc..."
read VM_suffix_ending

number_of_VMs=$(
for i in $(seq $VM_suffix_starting $VM_suffix_ending); do
    echo $i
done | wc -l
) 

echo "Creating $number_of_VMs KVM virtual machines..."
echo "Please wait..."

for i in $(seq $VM_suffix_starting $VM_suffix_ending); do 
    /data2/git/KVM/virt-manage-perl/provisioner.pl -n $VM_prefix$i
done
