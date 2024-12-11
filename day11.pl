#!/usr/bin/perl -w
use strict;

my $DEBUG=0;
my $MAXDEPTH = 75;
my %cache;

# Recursive function
sub calcfor {
  (my $val, my $depth) = @_;
  # Terminate before $MAXDEPTH+1'th blink
  # In that case there is just that one stone here.
  return 1 if($depth >= $MAXDEPTH);

  if(exists($cache{"$val,$depth"})) {
    $DEBUG && print "Returning cached $val,$depth\n";
    return $cache{"$val,$depth"};
  }

  my $ret = -1;
  my $strlen = length($val);
  if(($strlen & 1) == 0) {
    $DEBUG && print "Splitting $val\n";
    $strlen >>= 1;
    my $len1 = calcfor(int(substr($val, 0, $strlen)), $depth+1);
    my $len2 = calcfor(int(substr($val, $strlen)), $depth+1);
    $ret = $len1 + $len2;
  } elsif($val eq '0') {
    $DEBUG && print "Zero at depth $depth\n";
    $ret = calcfor(1, $depth+1);
  } else {
    $DEBUG && print "Multiplying $val\n";
    $ret = calcfor($val*2024, $depth+1);
  }
  $cache{"$val,$depth"} = $ret if $val < 1000;
  return $ret;
}

my $sum = 0;
my $row = <>;
chomp($row);
my @row = split(/ +/, $row);
foreach my $val (sort @row) {
  $sum += calcfor(int($val), 0);
}
print "$sum\n";
