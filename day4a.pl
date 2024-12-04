#!/usr/bin/perl -w
use strict;

my $sum = 0;
my $DEBUG=0;
my @matrix;
my @searchstr = ( 'X', 'M', 'A', 'S' );

while(<>) {
  chomp;
  /^[XMAS]*$/ || die "Invalid input $_";
  push @matrix, [ '.', '.', '.', split(//), '.', '.', '.' ];
}
my $xsize = $#{$matrix[0]}+1-6;
my @vsentinel = split(//, '.'x($#{$matrix[0]}+1));
push @matrix, \@vsentinel;
push @matrix, \@vsentinel;
push @matrix, \@vsentinel;
unshift @matrix, \@vsentinel;
unshift @matrix, \@vsentinel;
unshift @matrix, \@vsentinel;

# This is deep, yet remember, it's only O(count(chars)).
for(my $y=3; $matrix[$y] != \@vsentinel; $y++) {
  for(my $x=3; $x < $xsize+3; $x++) {
    if($matrix[$y][$x] eq $searchstr[0]) {
      for(my $yoff = -1; $yoff < 2; $yoff++) {
        for(my $xoff = -1; $xoff < 2; $xoff++) {
          next if($xoff == 0 && $yoff == 0);
          my $find=1;
          for(my $vlen=1; $vlen <= $#searchstr; $vlen++) {
            if($matrix[$y+$yoff*$vlen][$x+$xoff*$vlen] ne $searchstr[$vlen]) {
              $find=0;
              last;
            }
          }
          $find && $DEBUG && print "Match found at (", $x-3, ", ", $y-3, ") dir ($xoff, $yoff)\n";
          $sum += $find;
        }
      }
    }
  }
}

print $sum, "\n";
