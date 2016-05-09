#!/usr/bin/perl -w

my @lat;
my @lon;
my @name;

my $points = shift;
my $paths = shift;
die "Usage: command points.csv paths.csv" if ! defined $paths;

open INFO, $points || die "Cannot open $points: $!";
while (<INFO>) {
  chomp;
  my @F = split /\t/;
  $lat[$F[0]] = $F[1];
  $lon[$F[0]] = $F[2];
  $name[$F[0]] = $F[3];
}
close INFO;
open PATH, $paths || die "Cannot open $paths: $!";
while (<PATH>) {
  chomp;
  my ($node, $length, @plist) = split /\s/;
  my @cmd = ();
  push @cmd, "routino-router", "--profiles=./profiles.xml", 
  "--profile=retkiauto", "--output-gpx-track",  "--loop", "--output-stdout";
  my $n = 1;
  for my $id (@plist) {
    push @cmd, sprintf("--lon%d=%s", $n, $lon[$id]);
    push @cmd, sprintf("--lat%d=%s", $n, $lat[$id]);
    $n++;
  }
  push @cmd, sprintf("> %d.gpx", $node);
  system(join(" ", @cmd));
}
