#!/usr/bin/perl -w
use strict;

my $sum = 0;
my $DEBUG=0;
my @matrix;
my @searchstr = ( 'A' );
my %xmas = (
  'MMSS' => 1,
  'MSMS' => 1,
  'SSMM' => 1,
  'SMSM' => 1,
);

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

for(my $y=3; $matrix[$y] != \@vsentinel; $y++) {
  for(my $x=3; $x < $xsize+3; $x++) {
    if($matrix[$y][$x] eq $searchstr[0]) {
      my $mascircle = '';
      my $vlen = 1;
      for(my $yoff = -1; $yoff < 2; $yoff+=2) {
        for(my $xoff = -1; $xoff < 2; $xoff+=2) {
          $mascircle .= $matrix[$y+$yoff*$vlen][$x+$xoff*$vlen]
        }
      }
      if(exists($xmas{$mascircle})) {
        $DEBUG && print "Match found at (", $x-3, ", ", $y-3, ") pattern $mascircle\n";
        $sum++;
      }
    }
  }
}

print $sum, "\n";
