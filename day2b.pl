#!/usr/bin/perl -w
use strict;

my $score = 0;
my $MINDIFF = 1;
my $MAXDIFF = 3;
my $DEBUG=0;

sub issafe {
  my @report = @_;
  my $directional = 0;
  my $safe = 1;
  for(my $i=0; $i < $#report; $i++) {
    $directional += $report[$i] <=> $report[$i+1];
    my $diff = abs($report[$i] - $report[$i+1]);
    if($diff < $MINDIFF || $diff > $MAXDIFF) {
      $DEBUG && print join(' ', @report), ": Unsafe because $report[$i] $report[$i+1] too large.\n";
      $safe = 0;
      last;
    }
  }
  if($safe && abs($directional) != $#report) {
    $DEBUG && print join(' ', @report), ": Unsafe because $directional of $#report omnidirectional.\n";
    $safe = 0;
  }
  $DEBUG && print join(' ', @report), ": Safe.\n" if $safe;
  return $safe;
}
while(<>) {
  chomp;
  my @report = split(/ +/);
  my $safe = issafe(@report);
  for(my $i=0; !$safe && $i <= $#report; $i++) {
    my $e = splice(@report, $i, 1);
    $safe = issafe(@report);
    splice(@report, $i, 0, $e);
  }
  $score += $safe;
}
print $score, " reports are safe.\n";
