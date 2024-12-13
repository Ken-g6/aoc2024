#!/usr/bin/perl -w
use strict;
use Math::Complex;

my $sum = 0;
my $DEBUG=1;
my $OFFSET = 0; # or, for Part 2:
#$OFFSET = 10000000000000;

# Complex vectors
my ($va, $vb, $vx);

sub cost {
  (my $pa, my $pb) = @_;
  return 3*$pa + $pb;
}

my $MAX_PUSHES = 2*$OFFSET + 100;
my $MAX_COST = cost($MAX_PUSHES, $MAX_PUSHES);

while(<>) {
  chomp;
  if(/^Button A: X\+([0-9]+), Y\+([0-9]+)$/) {
    $va = Math::Complex->make($1, $2);
    next;
  }
  if(/^Button B: X\+([0-9]+), Y\+([0-9]+)$/) {
    $vb = Math::Complex->make($1, $2);
    next;
  }
  if(/^Prize: X=([0-9]+), Y=([0-9]+)$/) {
    $vx = Math::Complex->make($1 + $OFFSET, $2 + $OFFSET);

    my $min_cost = $MAX_COST; # An impossible number.
    my $best_pa = -1;
    my $best_pb = -1;
    my $pa = 0;
    my $max_pa = $MAX_PUSHES;
    # But, a formula falls out for pa = (Im(X) * Re(VB) - Im(VB) * Re(X)) / (Im(VA) * Re(VB) - Im(VB) * Re(VA))
    # It seems to work in cases where division by 0 doesn't happen. (Crosses fingers!)
    if(Im($va) * Re($vb) - Im($vb) * Re($va) != 0) {
      $pa = (Im($vx) * Re($vb) - Im($vb) * Re($vx)) / (Im($va) * Re($vb) - Im($vb) * Re($va));
      if($pa < 0 || $pa > $max_pa) {
        $DEBUG && print "No way to get to X=", Re($vx), ", Y=", Im($vx), " with $pa presses\n";
        next;
      }
      # Make $pa a range just to cover all bases.
      $pa = int($pa) - 1 if($pa >= 1);
      $max_pa = $pa+2;
    } else {
      warn "Division by 0 at vectors (X+", Re($va), ", Y+", Im($va), "), (X+", Re($vb), ", Y+", Im($vb), ")\n";
    }
    for(; $pa <= $max_pa; $pa++) {
      last if cost($pa,0) > $min_cost;
      # pb = (VX - pa*VA) / VB
      # But that division's no good for testing for integers.  Use modulus separately.
      # And the divisions have to be equal.
      my $xpa = $vx - $pa * $va;
      # Quit if negative pushes required.
      last if(Re($xpa) < 0 || Im($xpa) < 0);
      if(Re($xpa) % Re($vb) == 0 &&
        Im($xpa) % Im($vb) == 0 &&
        Re($xpa) / Re($vb) == Im($xpa) / Im($vb)
      ) {
        my $pb = Re($xpa) / Re($vb);
        my $cost = cost($pa, $pb);
        if($cost < $min_cost) {
          $min_cost = $cost;
          $best_pa = $pa;
          $best_pb = $pb;
        }
      }
    }
    if($min_cost < $MAX_COST) {
      $DEBUG && print "pa=$best_pa, pb=$best_pb => X=", Re($vx), ", Y=", Im($vx), "\n";
      $sum += $min_cost;
    } else {
      $DEBUG && print "No way to get to X=", Re($vx), ", Y=", Im($vx), "\n";
    }
  }
}
print $sum, "\n";
