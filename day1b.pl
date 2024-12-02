#!/usr/bin/perl
# -w
use strict;

my @list1;
my %list2;
my $score = 0;
while(<>) {
  (my $le1, my $le2) = /^([0-9]+) +([0-9]+)/;
  push @list1, $le1;
  $list2{$le2}++;
}

my $i=0;
foreach my $le1 (@list1) {
  $i++;
  #print "The ${i}th number in the left list is $le1. It appears in the right list " . $list2{$le1} . " times, so the similarity score increases by $le1 * " . $list2{$le1} . " = " . ($le1 * $list2{$le1}) . ".\n";
  $score += $le1 * $list2{$le1};
}
print $score, "\n";
