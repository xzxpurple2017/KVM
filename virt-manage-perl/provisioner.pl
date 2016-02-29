#!/usr/bin/perl
#
# pdam@intacct.com
#
# Automates creating new KVM virtual machines.

use strict;
use warnings;
use Sys::Virt;
use File::Basename;
use Getopt::Long;
use Data::UUID;
use File::Copy qw(copy);
use File::Slurp qw(read_file write_file);
                 
my $progname = basename($0);                                                                      

my $usage = << "EOF";

This script is used to automate the creation of KVM virtual machines.

Usage: $progname\t[-n] [--new]	Create new VM.		                
                \t[-h] [--help]	Displays usage information.
EOF

my $vm_name		= '';
my $help                = '';

GetOptions ("new=s"	=> \$vm_name,
            "help"	=> \$help)
or die("\nUsage: $progname [OPTION]...\nTry $progname -h, --help for more information.\n");

if ($help) {
    print "$usage\n";
    exit 0
}

# Preparing the new images and config files
 
my $vm_config_master = "/data2/kvm-config/qemu/centos6-base-provisioning.xml";
my $vm_image_master  = "/data2/kvm-images/centos6-base.img";         

my $vm_config_new    = "/data2/kvm-config/qemu/$vm_name.xml";
my $vm_image_new     = "/data2/kvm-images/$vm_name.img";

print "Provisioning KVM virtual machine $vm_name. Please wait...\n";
copy $vm_config_master, $vm_config_new;
copy $vm_image_master, $vm_image_new;
print "Booting KVM virtual machine. Almost done...\n";

# Generating new UUID for each VM

my $ug   = Data::UUID->new;
my $UUID = $ug->create_from_name_str($vm_config_new, $vm_name);        # UUID for each VM

# Generating random MAC address for each VM

my $NIC = join(":", map { sprintf "%0.2X",rand(256) }(1..3));
my $MAC = "52:54:00:$NIC";                                             # MAC for each VM

# Editing XML file

my $xml_configs = read_file $vm_config_new, {binmode => ':utf8'};      # The XML file has 4 unique fields per VM
$xml_configs =~ s/REPLACE_NAME/$vm_name/g;
$xml_configs =~ s/REPLACE_UUID/$UUID/g;
$xml_configs =~ s/REPLACE_PATH/$vm_image_new/g;
$xml_configs =~ s/REPLACE_MAC/$MAC/g;
write_file $vm_config_new, {binmode => ':utf8'}, $xml_configs;

# Create VM from XML file
  
open(my $fh, '<', $vm_config_new);
my $xml = do { local ($/); <$fh> };

my $con = Sys::Virt->new('uri' => "qemu:///system");   
my $dom = $con->create_domain($xml);
    
