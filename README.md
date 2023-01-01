# KVM
Experimental Linux KVM projects

## Creating CentOS Stream 9 virtual machine
This assumes that KVM, libvirt, and associated tools have been installed. 
Usually, there is a folder called ~/.local/share/libvirt/images/ that is 
created in the user's home directory. 

The following can be run from a CentOS Stream 9 host and creates a
CentOS Stream 9 guest image that will be used as a template image. 

Make sure you have downloaded a CentOS Stream 9 ISO into your home directory as well.
```
    qemu-img create -f qcow2 ~/.local/share/libvirt/images/gold-template-image.qcow2 20G

    virt-install \
      --name gold-template-centos-stream-9-vm \
      --ram 2048 \
      --disk path=~/.local/share/libvirt/images/gold-template-image.qcow2,size=20 \
      --vcpus 2 \
      --os-variant centos-stream9 \
      --network bridge=virbr0,model=virtio \
      --graphics none \
      --console pty,target_type=serial \
      --location ~/CentOS-Stream-9-latest-x86_64-dvd1.iso \
      --extra-args 'console=ttyS0,115200n8'
```

## Provisioning new virtual machine
```
    cd KVM
    ./provisioning/provision_virtual_machine.sh
```
