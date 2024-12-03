#!/usr/bin/perl -w
use strict;

my $sum = 0;
my $DEBUG=0;

while(<>) {
  my @muls = (/mul\([0-9]+,[0-9]+\)/g);
  foreach my $mul (@muls) {
    $mul =~ /^mul\(([0-9]+),([0-9]+)\)$/;
    $DEBUG && print "$1*$2\n";
    $sum += $1*$2;
  }
}
print $sum, "\n";
