#!/usr/bin/perl -w

my @lat;
my @lon;
my @name;
my @fname;

my $points = shift;
my $paths = shift;
die "Usage: command points.csv paths.csv" if ! defined $paths;

open INFO, $points || die "Cannot open $points: $!";
while (<INFO>) {
  chomp;
  my @F = split /\t/;
  $lat[$F[0]] = $F[1];
  $lon[$F[0]] = $F[2];
  $fname[$F[0]] =  $name[$F[0]] = $F[3];
  $fname[$F[0]] =~ tr/A-Za-z-//cds;
}
close INFO;
open PATH, $paths || die "Cannot open $paths: $!";
while (<PATH>) {
  chomp;
  my ($node, $length, @plist) = split /\s/;
  my @cmd = ();
  my $outdir = "parts-$node";
  -d $outdir || mkdir $outdir;
  push @cmd, "routino-router", "--profiles=./profiles.xml", 
  "--profile=retkiauto";
  push @plist, $plist[0];	# make circular
  for my $n (1..$#plist) {
    system (@cmd,
	    sprintf("--lon1=%s", $lon[$plist[$n-1]]),
	    sprintf("--lat1=%s", $lat[$plist[$n-1]]),
	    sprintf("--lon2=%s", $lon[$plist[$n]]),
	    sprintf("--lat2=%s", $lat[$plist[$n]]));
    for my $file (qw/shortest.txt shortest-track.gpx shortest-route.gpx shortest.html shortest-all.txt/) {
      rename $file, sprintf("%s/%02d_%s-%s_%s", $outdir, $n,
			    $fname[$plist[$n-1]], $fname[$plist[$n]], $file);
    }
  }
}
