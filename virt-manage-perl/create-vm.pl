#!/usr/bin/env perl

use strict;
use warnings;
 
use Sys::Virt;
 
my $con = Sys::Virt->new('uri' => "qemu:///system");
 
# Create vm guest from xml file

my $path = '/data2/kvm-config/qemu/test.xml';
  
open(my $fh, '<', $path);
my $xml = do { local ($/); <$fh> };
   
my $dom = $con->create_domain($xml);
    
# Retrieve the running guest VMs id,name,status
my @gdomains = $con->list_domains();
     
foreach my $gdom ( @gdomains ) {
    print "Domain name ", $gdom->get_name, "\n";
    print "Domain ID ", $gdom->get_id, "\n";
}
