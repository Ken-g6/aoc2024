#!/usr/bin/perl -w
use strict;

my $sum = 0;
my $DEBUG=0;

# Recursive function
sub calcfor {
  (my $arr, my $idx, my $sofar, my $goal) = @_;
  # Terminate at end of array.
  if($idx > $#{$arr}) {
    return $sofar == $goal;
  }
  foreach my $next ($sofar * $arr->[$idx], int("$sofar$arr->[$idx]"), $sofar + $arr->[$idx]) {
    # Basic bound - can do better, but turned out to be enough.
    if($next <= $goal) {
      if(calcfor($arr, $idx+1, $next, $goal)) {
        # Terminate early on success.
        return 1;
      }
    }
  }

  return 0;
}

while(<>) {
  chomp;
  my @row = split(/[: ]+/);
  $sum += $row[0] if(calcfor(\@row, 2, $row[1], $row[0]));
}
print $sum, "\n";
