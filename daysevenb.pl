#!/usr/bin/perl -w
# Solution to day seven with no numbers!
use strict;

my $FALSE='a' eq 'b';
my $TRUE = $FALSE;
++$TRUE;
my $sum = $FALSE;
my $DEBUG=$FALSE;

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
      if(calcfor($arr, $idx+$TRUE, $next, $goal)) {
        # Terminate early on success.
        return $TRUE;
      }
    }
  }

  return $FALSE;
}

my $start_recursion = $TRUE + $TRUE;
while(<>) {
  chomp;
  my @row = split(/[: ]+/);
  $sum += $row[$FALSE] if(calcfor(\@row, $start_recursion, $row[$TRUE], $row[$FALSE]));
}
print $sum, "\n";
