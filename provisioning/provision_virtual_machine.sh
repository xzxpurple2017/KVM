#!/bin/bash

read -p "Please enter new virtual machine name: " vm_name

# Prompt for sudo password first
sudo bash -c 'echo'

IMAGE_POOL="/home/philip/.local/share/libvirt/images"
GOLD_VM_NAME="gold-template-centos-stream-9-vm"
NETWORK="default"

echo "# Cloning new virtual machine"
echo
virt-clone \
  --original gold-template-centos-stream-9-vm \
  --name $vm_name \
  --file "${IMAGE_POOL}/managed-vm-$( tr -dc A-Za-z0-9 </dev/urandom | head -c 16 ; echo '' ).qcow2"
ret=$?
if [[ $ret -ne 0 ]] ; then
    echo
    echo "# ERROR - Failed to clone virtual machine from gold, see message above"
    exit 1
fi

echo
echo "# Starting '$vm_name'"
echo
virsh start $vm_name

# Check if guest is running
sleep 3
is_running=$( virsh list | grep -oP "${vm_name}.*running" )
counter=0
while [[ -z $is_running ]] ; do
    sleep 2
    is_running=$( virsh list | grep -oP "${vm_name}.*running" )
    if [[ $counter -eq 60 ]] ; then
        echo "# ERROR - Timeout occurred while waiting for virtual machine to start"
        exit 1
    fi
    ((counter++))
done

echo "# '$vm_name' has started up"

mac_address=$( virsh domiflist $vm_name | awk '{ print $5 }' | tail -2 | head -1 )
echo "# MAC address is '$mac_address'"

# IP address can take a long time for host to assign
ip_address=$( sudo virsh net-dhcp-leases $NETWORK | grep $mac_address | awk '{print $5}' | grep -oP '\d+.\d+.\d+.\d+' )
counter=0
while [[ -z $ip_address ]] ; do
    sleep 1
    ip_address=$( sudo virsh net-dhcp-leases $NETWORK | grep $mac_address | awk '{print $5}' | grep -oP '\d+.\d+.\d+.\d+' )
    if [[ $counter -eq 60 ]] ; then
        echo "# ERROR - Timeout occurred while searching for IP address"
        exit 1
    fi
    ((counter++))
done
echo "# IP address is '$ip_address'"

echo "# Adding to DHCP IP pool"

sudo virsh net-update \
  $NETWORK add ip-dhcp-host \
  "<host mac='$mac_address' name='$vm_name' ip='$ip_address'/>" \
  --live \
  --config

echo
echo "# Rebooting '$vm_name' for hostname changes to take effect"
echo
virsh reboot $vm_name
