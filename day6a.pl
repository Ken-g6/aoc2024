#!/usr/bin/perl -w
use strict;

# Redone from 2023 Day 16.  Can you tell?

my $DEBUG = 0;

my $NORTH=0;
my $EAST=1;
my $SOUTH=2;
my $WEST=3;
my %direction_map = (
  # If you hit a '.' keep traveling the way you were going, and don't split.  Never split, right?
  '.' => [ [ $NORTH ], [ $EAST ], [ $SOUTH ], [ $WEST ] ], 
  # Hitting a mirror - I mean obstacle - changes direction.
  '#' => [ [ $EAST ], [ $SOUTH ], [ $WEST ], [ $NORTH ] ], 
  #'\\' => [ [ $WEST ], [ $SOUTH ], [ $EAST ], [ $NORTH ] ], 
  # Hitting a splitter - what's that? - *may* split the beam.
  #'-' => [ [ $EAST, $WEST ], [ $EAST ], [ $EAST, $WEST ], [ $WEST ] ], 
  #'|' => [ [ $NORTH ], [ $NORTH, $SOUTH ], [ $SOUTH ], [ $NORTH, $SOUTH ] ], 
  # Hitting a black hole (sentinel) stops a light beam. :)
  'O' => [ [ ], [ ], [ ], [ ] ]
);

my @guard_dir = ( '^', '>', 'v', '<' );
# Take a step in each direction.
my @step_in_direction = ( [ 0, -1 ], [ 1, 0 ], [ 0, 1 ], [ -1, 0 ] );
# When running into an obstacle, we need to step back.
my @step_back = ( [ 0, 1 ], [ -1, 0 ], [ 0, -1 ], [ 1, 0 ] );
my @contraption;
# Where are the many split photons of light right now, and where are they going?
# Format [ x, y, direction ]
# I won't need a Heisenberg compensator.
my @locations;

my $startx=-1;
my $starty=1;
while(<>) {
  s/[ \r\n]*$//s;
  next if /^$/;
  die "Invalid contraption $_" unless /^[.#^]+$/;
  # Add sentinels on the sides.
  push @contraption, [ 'O', split(//), 'O' ];
  if(/\^/) {
    my $row = $contraption[$#contraption];
    for($startx=1; $startx < $#{$row}; $startx++) {
      if($row->[$startx] eq '^') {
        # The guard is standing on a blank tile, not an obstacle or other thing.
        $row->[$startx] = '.';
        last;
      }
    }
  }
  $starty++ unless $startx > 0;
}
my $topsentinel = 'O'x($#{$contraption[0]} + 2);
$topsentinel = [ split(//, $topsentinel) ];
unshift(@contraption, $topsentinel);
push(@contraption, $topsentinel); # So it's also bottom sentinel.

# A map of where photon has heated a tile, traveling in each direction.
my @heatmap; 
for(my $y=0; $y <= $#contraption; $y++) {
  $heatmap[$y] = [];
  for(my $x=0; $x <= $#{$contraption[$y]}; $x++) {
    push @{$heatmap[$y]}, 0;
  }
}

# You are an adventuring photon in a cave.
# It is pitch black (because you haven't lighted anything yet!)
# You are likely to be eaten by a grue - or a heating tile - or a black hole - or something!
$locations[0] = [ $startx, $starty, $NORTH ];
while($#locations >= 0) {
  if($DEBUG) {
    for(my $y=1; $y < $#contraption; $y++) {
      for(my $x=1; $x < $#{$contraption[$y]}; $x++) {
        if($locations[0][0] == $x && $locations[0][1] == $y) {
          print $guard_dir[$locations[0][2]];
        } elsif($heatmap[$y][$x] > 0) {
          print 'X';
        } else {
          print $contraption[$y][$x];
        }
      }
      print "\n";
    }
    print "-----------------------------\n";
  }
  my $location = pop @locations;
  (my $x, my $y, my $direction) = @$location;

  #if($heatmap[$y][$x][$direction] != 0) {
  #warn "Quantum interference at $x, $y\n";
  #next;
  #}
  $heatmap[$y][$x] = 1 unless $contraption[$y][$x] ne '.';

  my $directions = $direction_map{$contraption[$y][$x]}[$direction];
  foreach my $dir (@$directions) {
    my $step;
    if($contraption[$y][$x] ne '#') {
      $step = $step_in_direction[$dir];
    } else {
      # Step back in the direction we came from.
      $step = $step_back[$direction];
    }

    push @locations, [ $x + $$step[0], $y + $$step[1], $dir ];
  }
}

# Sum heated tiles, but ignore heated black holes.
my $heat_tot=0;
for(my $y=1; $y < $#contraption; $y++) {
  for(my $x=1; $x < $#{$contraption[$y]}; $x++) {
    my $heated = $heatmap[$y][$x];
    $heat_tot++ if $heated != 0;
    if($heated == 0) { $heated = '.'; }
    elsif($heated == 1) { $heated = '#' };
    print $heated;
  }
  print "\n";
}
print $heat_tot, "\n";
