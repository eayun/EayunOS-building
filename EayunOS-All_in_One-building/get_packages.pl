#!/usr/bin/env perl -w
use strict;
use XML::Simple;
use WWW::Curl::Easy;
use IO::Uncompress::Gunzip;

my %packages = (
    'core' => 1,
    'epel' => 1,
    'ovirt' => 1,
);
my %baseurl = (
    'core' => 'http://127.0.0.1/rpms/centos65/x86_64',
    'epel' => 'http://127.0.0.1/rpms/epel/6/x86_64/',
    'ovirt' => 'http://127.0.0.1/rpms/eayunOS/RPMS/',
);
my $dest;
my $comps_file;

sub download_package {
    my ($package, $url) = @_;
    my $curl = WWW::Curl::Easy->new;
    $curl->setopt(CURLOPT_HEADER, 0);
    $curl->setopt(CURLOPT_URL, $url.$package);
    $package =~ s{^[^/]+/}{};
    print "$dest$package\n";
    open(my $fh, ">", $dest.$package) or die;
    $curl->setopt(CURLOPT_WRITEDATA, $fh);
    my $retcode = $curl->perform;
    close $fh;
    die unless ($retcode == 0);
}

sub get_packages_list {
    my $xml = XML::Simple->new('KeyAttr' => {'group' => 'id', 'packagereq' => 'content'});
    my $data = $xml->XMLin($comps_file);
    foreach (keys %packages) {
        $packages{$_} = $data->{group}->{$_}->{packagelist}->{packagereq};
    }
}

sub get_packages {
    foreach (keys %baseurl) {
        my $component = $_;
        my $curl = WWW::Curl::Easy->new;
        my $response_body;
        $curl->setopt(CURLOPT_HEADER, 0);
        $curl->setopt(CURLOPT_URL, $baseurl{$_}."repodata/primary.xml.gz");

	    open(my $fb, ">", \$response_body);
        $curl->setopt(CURLOPT_WRITEDATA, $fb);
        my $retcode = $curl->perform();
	    close $fb;

        if ($retcode == 0) {
            my $buffer;
            IO::Uncompress::Gunzip::gunzip \$response_body => \$buffer;
            my $xml = XML::Simple->new(KeyAttr => {'package' => 'name'});
            my $data = $xml->XMLin($buffer);
	        
            my $tmphash = $packages{$component};
            foreach (keys %$tmphash) {
                my $package = $data->{package}->{$_}->{location}->{href};
                if ($package) {
                    download_package($package, $baseurl{$component});
                }
            }
        }
    }
}

$comps_file = shift;
$dest = shift;
get_packages_list;
get_packages;
