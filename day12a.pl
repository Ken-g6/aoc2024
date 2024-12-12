#!/usr/bin/perl -w
use strict;
use Math::Vector::Real;

my $sum = 0;
my $DEBUG=0;
my @matrix;
my %area;
my %perimiter;

sub pos2xy {
  (my $base) = @_;
  return ( $base->[0], $base->[1] );
}

while(<>) {
  chomp;
  /^[A-Z]*$/ || die "Invalid input $_";
  push @matrix, [ '.', split(//), '.' ];
}
my $xsize = $#{$matrix[0]};
my @vsentinel = split(//, '.'x($#{$matrix[0]}+1));
push @matrix, \@vsentinel;
unshift @matrix, \@vsentinel;

# First, flood fill these regions with numbers instead so they're all unique.
my $fillto = 0;
my %fillmap;
for(my $y=1; $y < $#matrix; $y++) {
  for(my $x=1; $x < $xsize; $x++) {
    if($matrix[$y][$x] =~ /^[A-Z]$/) {
      my $fillfrom = $matrix[$y][$x];
      $fillmap{$fillto} = $fillfrom;
      my @filling = ( V($x, $y) );
      my $fillcount = 0;
      while($#filling >= 0) {
        my $pos = shift(@filling);
        (my $xf, my $yf) = pos2xy($pos);
        if($matrix[$yf][$xf] eq $fillfrom) {
          $matrix[$yf][$xf] = $fillto;
          $fillcount++;
          for(my $d = -1; $d <= 1; $d++) {
            if($matrix[$yf][$xf+$d] eq $fillfrom) {
              push @filling, V($xf+$d, $yf);
            }
            if($matrix[$yf+$d][$xf] eq $fillfrom) {
              push @filling, V($xf, $yf+$d);
            }
          }
        }
      }
      $DEBUG && print "Filled a region of $fillcount $fillfrom plants with $fillto\n";
      $fillto++;
    }
  }
}

# Sentinels should be numbers too: -1.
for(my $y=1; $y < $#matrix; $y++) {
  $matrix[$y][0] = -1;
  $matrix[$y][$xsize] = -1;
}
for(my $x=0; $x <= $xsize; $x++) {
  $vsentinel[$x] = -1;
}

# Find areas and boundaries.
# Yes, including the first sentinel, but not all the way to the last sentinel.
for(my $y=0; $y < $#matrix; $y++) {
  for(my $x=0; $x < $xsize; $x++) {
    ++$area{$matrix[$y][$x]};
    if($matrix[$y][$x] != $matrix[$y][$x+1]) {
      $perimiter{$matrix[$y][$x]}++;
      $perimiter{$matrix[$y][$x+1]}++;
    }
    if($matrix[$y][$x] != $matrix[$y+1][$x]) {
      $perimiter{$matrix[$y][$x]}++;
      $perimiter{$matrix[$y+1][$x]}++;
    }
  }
}

foreach my $plot (sort keys(%area)) {
  next if $plot < 0;
  my $prod = $area{$plot} * $perimiter{$plot};
  $DEBUG && print "A region #$plot of $fillmap{$plot} plants with price $area{$plot} * $perimiter{$plot} = $prod.\n";
  $sum += $prod;
}

print $sum, "\n";
