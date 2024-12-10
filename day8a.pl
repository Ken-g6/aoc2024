#!/usr/bin/perl -w
use strict;

my $DEBUG=1;
# Format: $antenna{$freq} = [ [ $x, $y ] .. ]
my %antenna;
my @antinode;

# Poor man's vector class.
sub vector {
  return [ $_[0], $_[1] ];
}
# $_[0] + $_[1], as vectors.
sub vecsum {
  return [ $_[0]->[0] + $_[1]->[0], $_[0]->[1] + $_[1]->[1] ];
}
# $_[0] - $_[1], as vectors.
sub vecdiff {
  return [ $_[0]->[0] - $_[1]->[0], $_[0]->[1] - $_[1]->[1] ];
}
# - $_[0], as vector.
sub vecneg {
  return [ -$_[0]->[0], -$_[0]->[1] ];
}

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

# Using Euclidian Algorithm from https://stackoverflow.com/questions/24610899/finding-the-gcd-of-two-numbers-quickly
sub gcd {
    my ( $quotient, $divisor ) = @_;

    return $divisor if $quotient == 0;
    return $quotient if $divisor == 0;

    while () {
        my $remainder = $quotient % $divisor;
        return $divisor if $remainder == 0;
        $quotient = $divisor;
        $divisor = $remainder;
    }
}

sub vecsimplify {
  my $vec = $_[0];
  my $d = gcd($vec->[0], $vec->[1]);
  return [ $vec->[0] / $d, $vec->[1] / $d ];
}

# Vector times a scalar
sub vecmulscalar {
  my ( $vec, $s ) = @_;
  return [ $vec->[0] * $s, $vec->[1] * $s ];
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
    push @{$antenna{$c}}, vector($x, $y);
  }
  $y++;
}

foreach my $list (values(%antenna)) {
  for(my $i=0; $i <= $#{$list}; $i++) {
    for(my $j=$i+1; $j <= $#{$list}; $j++) {
      # Antinodes at i-(j-i), j+(j-i)
      my $diff = vecdiff($list->[$j], $list->[$i]);
      vecplot(vecdiff($list->[$i], $diff));
      vecplot(vecsum($list->[$j], $diff));
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
