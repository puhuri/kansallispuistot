#!/usr/bin/perl -w

my @lat;
my @lon;
my @name;

my $infile = $ARGV[0];
while (<>) {
  chomp;
  my @F = split /\t/;
  $lat[$F[0]] = $F[1];
  $lon[$F[0]] = $F[2];
  $name[$F[0]] = $F[3];
}

open LOG, ">matrix-" . $infile . ".log" || die "Cannot open log: $!";
print LOG join("\t", "wpA", "wpB", "distance", "duration", "latA", "lonA", "latB", "lonB", "nameA", "nameB"), "\n";
for my $a (0..$#lat) {
  next if ! defined $lat[$a];
  for my $b (0..$#lat) {
    next if ! defined $lat[$b];
    next if $a == $b;
    open X, "routino-router --lat1=$lat[$a] --lon1=$lon[$a] --lat2=$lat[$b] --lon2=$lon[$b] --quickest --profiles=./profiles.xml --profile=retkiauto --output-stdout --output-text |" || die "Routino failed: $!";
    my ($la, $lo, $pl, $pt, $cl, $lt, $type, $be, $hw) = ();
    while (<X>) {
      next if m/^#/;
      chomp;
      ($la, $lo, $pl, $pt, $cl, $ct, $type, $be, $hw) = split /\t/;
    }
    $cl =~ s/ km//;
    $ct =~ s/ min//;
    print LOG join("\t", $a, $b, $cl, $ct, $lat[$a], $lon[$a], $lat[$b], $lon[$b], $name[$a], $name[$b]), "\n";
    print join("\t", $a, $b, $cl, $ct, $name[$a], $name[$b]), "\n";
  }
}
