#!/bin/bash

#Creates the necessary XML files
#Don't forget to provide the absolute path for the xml-provisioner.py
for i in $(cat list_of_vms.txt); do
	python xml-provisioner.py $i
done

#Moves XML files from current directory to /etc/libvirt/qemu
#But we don't want to just copy every single XML file, just the ones defined by user
for i in $(cat list_of_vms.txt); do
	cp $i.xml /etc/libvirt/qemu
done

#Creates the necessary VM images from existing master copy
for i in $(cat list_of_vms.txt); do
	cp /var/lib/libvirt/images/centos6-base.img /var/lib/libvirt/images/$i.img
done
