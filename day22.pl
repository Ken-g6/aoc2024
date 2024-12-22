#!/usr/bin/perl -w
use strict;
use List::Util qw( max );

my $sum = 0;
my $DEBUG=0;
my $PRUNE=(1<<24)-1;

sub step {
  my $s = $_[0];
  my $s2=((($s<<6)&$PRUNE)^$s);
  my $s3=$s2^($s2>>5);
  my $s4=(($s3<<11)&$PRUNE)^$s3;
  return $s4;
}

#print "if a buyer had a secret number of 123, that buyer's next ten secret numbers would be:\n";
#for(my ($i,$s)=(0,123); $i < 10; $i++) {
#$s = step($s);
#print "$s\n";
#}

my %tmps; # Total number of Monkey Price Sequences seen.
while(<>) {
  chomp;
  my $s=int($_);
  my $s0 = $s;
  my %mps; # Seen Monkey Price Sequences
  my $lastmp = $s%10;
  my @cmps = ( ); # Current Monkey Price Sequence
  for(my $i=0; $i < 2000; $i++) {
    $s = step($s);
    my $mp = $s % 10;
    push @cmps, ($mp - $lastmp);
    $lastmp = $mp;
    shift @cmps if $#cmps >= 4;
    my $mpsstr = join(',',@cmps);
    if($#cmps == 3 && !exists($mps{$mpsstr})) {
      $mps{$mpsstr} = $mp;
      #print "Adding monkey price sequence $mpsstr = $mp\n";
    }
  }
  foreach my $k (keys %mps) {
    $tmps{$k} += $mps{$k};
  }
  #print "$s0: $s\n";
  #print "mps{'-2,1,-1,3'} = ", $mps{"-2,1,-1,3"}, "\n";
  $sum += $s;
}
print "Part 1: $sum\n";
print "Part 2: ", max(values(%tmps)), "\n";
