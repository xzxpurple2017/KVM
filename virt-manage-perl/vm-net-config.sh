#!/bin/bash

# Note: Only works for default nat KVM virtual machines running on 1 host.

echo "Please enter starting VM number"
read COUNTER

echo "Please enter ending VM number"
read END

HOST_COUNTER=$COUNTER
CONFIG_COUNTER=$COUNTER

for a in $(for j in $(for i in `seq $COUNTER..$END`; do
    sudo cat /data2/kvm-config/qemu/vm-server$i.xml | grep -i 52:54:00 | sed "s/<mac address='//g" | sed "s/'\/>//g" 
done); do
    arp -an | grep -i $j; done | awk '{print $2}' | sed 's/(//g' | sed 's/)//g' | grep -i 192.168.122); do
ssh $a "sudo sed -i 's/vm-server1/vm-server$HOST_COUNTER/g' /etc/sysconfig/network"; let HOST_COUNTER=HOST_COUNTER+1
    done

for a in $(for j in $(for i in `seq $COUNTER..$END`; do
    sudo cat vm-server$i.xml | grep -i 52:54:00 | sed "s/<mac address='//g" | sed "s/'\/>//g" 
done); do
    arp -an | grep -i $j; done | awk '{print $2}' | sed 's/(//g' | sed 's/)//g' | grep -i 192.168.122); do
echo "$a vm-server$CONFIG_COUNTER" | sudo tee -a /etc/hosts; let CONFIG_COUNTER=CONFIG_COUNTER+1
    done
