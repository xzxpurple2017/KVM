#!/usr/bin/env perl

use strict;
use warnings;
use Sys::Virt;

my $con = Sys::Virt->new('uri' => "qemu:///system");

# Retrieve the running guest VMs id,name,status

my @gdomains = $con->list_domains();

foreach my $gdom ( @gdomains ) {
    print "Domain name ", $gdom->get_name, $gdom->shutdown, " is being shutdown", "\n";
}
