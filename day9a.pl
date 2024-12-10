#!/usr/bin/perl -w
use strict;

my $DEBUG=0;
my $EMPTY=-1;
my @fs;

sub printfs {
  for(my $i=0; $i <= $#fs; $i++) {
    if($fs[$i] < 0) {
      print '.';
    } else {
      print $fs[$i] % 10;
    }
  }
  print "\n";
}

# Part 1: Populate @fs.
my $inline = <>;
chomp($inline);
my @inline = split(//, $inline);

my $fileno = 0;
for(my $i=0; $i <= $#inline; $i+=2) {
  for(my $j=0; $j < $inline[$i]; $j++) {
    push @fs, $fileno;
  }
  $fileno++;
  if($i+1 <= $#inline) {
    for(my $j=0; $j < $inline[$i+1]; $j++) {
      push @fs, $EMPTY;
    }
  }
}
$DEBUG && printfs;

# Part 2: Defrag @fs.
my $from = $#fs;
my $to = 0;
while($from > $to) {
  # Find a place for a block.
  $to++ while($fs[$to] != $EMPTY && $from > $to);
  # Find a block to place.
  $from-- while($fs[$from] == $EMPTY && $from > $to);
  last if ($from <= $to);
  # We have a block and a place to put it.  Defrag it!
  $fs[$to] = $fs[$from];
  $fs[$from] = $EMPTY;
  $DEBUG && printfs;
}

# Part 3: Checksum @fs.
my $sum = 0;
for(my $i=0; $i <= $#fs; $i++) {
  # If properly defragged, this should trigger at the end of all used blocks.
  last if $fs[$i] == $EMPTY;
  $sum += $i * $fs[$i];
}

print $sum, "\n";
