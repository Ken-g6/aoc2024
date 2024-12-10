#!/usr/bin/perl -w
use strict;
use Math::Vector::Real;
use Math::Prime::Util::GMP qw(gcd);

my $DEBUG=0;
# Format: $antenna{$freq} = [ [ $x, $y ] .. ]
my %antenna;
my @antinode;

# We'll always plot on @antinode for simplicity.
sub vecplot {
  my $v = $_[0];

  $DEBUG && print "Attempting to plot ($v->[0], $v->[1])\n";
  if($v->[1] >= 0 && $v->[1] <= $#antinode) {
    my $y = $v->[1];
    my $x = $v->[0];
    if($x >= 0 && $x <= $#{$antinode[$y]}) {
      $antinode[$y]->[$x] = '#';
      return 1;
    }
  }
  return 0;
}

sub vecsimplify {
  my $vec = $_[0];
  my $d = gcd($vec->[0], $vec->[1]);
  return V($vec->[0] / $d, $vec->[1] / $d);
}

my $y=0;
while(<>) {
  chomp;
  my @row = split(//);
  my $blank = $_;
  $blank =~ s/././g;
  push @antinode, [ split(//, $blank) ];
  for(my $x=0; $x <= $#row; $x++) {
    my $c = $row[$x];
    next unless $c =~ /^[a-zA-Z0-9]$/;
    $antenna{$c} = [] if !exists($antenna{$c});
    push @{$antenna{$c}}, V($x, $y);
  }
  $y++;
}

foreach my $list (values(%antenna)) {
  for(my $i=0; $i <= $#{$list}; $i++) {
    for(my $j=$i+1; $j <= $#{$list}; $j++) {
      my $diff = vecsimplify($list->[$j] - $list->[$i]);
      for(my $s=0; ; $s++) {
        last unless vecplot($list->[$j] + ($diff * $s));
      }
      for(my $s=1; ; $s++) {
        last unless vecplot($list->[$j] + ($diff * (-$s)));
      }
    }
  }
}

# Sum heated tiles, but ignore heated black holes.
my $heat_tot=0;
for(my $y=0; $y <= $#antinode; $y++) {
  for(my $x=0; $x <= $#{$antinode[$y]}; $x++) {
    my $heated = $antinode[$y]->[$x];
    $heat_tot++ if $heated eq '#';
    print $heated if $DEBUG;
  }
  print "\n" if $DEBUG;
}
print $heat_tot, "\n";
