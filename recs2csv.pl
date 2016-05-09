#!/usr/bin/perl -w

use strict;

sub dm2d {
  if ($_[0] =~ m/(lat|lon): (-?\d+)\D+(\d+\.\d+)/) {
    return $2 + $3 / 60.0;
  }
  warn "Invalid coordinates: $_[0]";
  return undef;
}

$/ = "\n\n";

my $i = 1;
while (<>) {
  my ($kp, $pp, $lat, $lon, @rest) = split("\n", $_);
  print join("\t", $i++, dm2d($lat), dm2d($lon), $kp, $pp), "\n";
}
