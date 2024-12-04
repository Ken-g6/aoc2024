#!/usr/bin/perl -w
use strict;

my $sum = 0;
my $DEBUG=0;
my $mulstr = "";

while(<>) {
  chomp;
  $mulstr .= " $_";
}
$mulstr =~ s/don't\(\).*?(do\(\)|$)//g;
my @muls = ($mulstr =~ /mul\([0-9]+,[0-9]+\)/g);
foreach my $mul (@muls) {
  $mul =~ /^mul\(([0-9]+),([0-9]+)\)$/;
  $DEBUG && print "$1*$2\n";
  $sum += $1*$2;
}
print $sum, "\n";
