#!/usr/bin/perl -w
# Day 2, but efficient.  Instead of splice, rearrange the array elements.
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
  if(!$safe) {
    # Go from last to first, like insertion sort, popping an element out into $saved_element.
    my $old_saved_element = -1;
    my $new_saved_element = pop @report;
    $safe = issafe(@report);
    for(my $i=$#report; !$safe && $i >= 0; $i--) {
      $old_saved_element = $new_saved_element;
      $new_saved_element = $report[$i];
      $report[$i] = $old_saved_element;
      $safe = issafe(@report);
    }
  }
  $score += $safe;
}
print $score, " reports are safe.\n";
