#!/usr/bin/env perl -w
use strict;
use XML::Simple;

my $comps_file = shift;

my $xml = XML::Simple->new('KeyAttr' => {'group' => 'id', 'packagereq' => 'content'});
my $data = $xml->XMLin($comps_file);

#use Data::Dumper;
#print Dumper($data);
my $group_hash = $data->{group};
my @packages_list;
foreach (keys %$group_hash) {
    my $packagelist_hash = $group_hash->{$_}->{packagelist}->{packagereq};
    foreach (keys %$packagelist_hash) {
        push @packages_list, $_;
    }
}

print "@packages_list";
