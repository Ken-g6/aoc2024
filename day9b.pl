#!/usr/bin/perl -w
use strict;

my $DEBUG=0;
my $EMPTY=-1;

my @filepos;
my @filelen;
my @emptypos;
my @emptylen;

sub printfs {
  my @fs;
  for(my $i=0; $i < $emptypos[$#emptypos] + 20; $i++) {
    push @fs, $EMPTY;
  }
  for(my $i=0; $i <= $#filepos; $i++) {
    for(my $j=0; $j < $filelen[$i]; $j++) {
      $fs[$filepos[$i]+$j] = $i % 10;
    }
  }
  for(my $i=0; $i < $emptypos[$#emptypos] + 20; $i++) {
    $fs[$i] = '.' if $fs[$i] == $EMPTY;
  }
  print(join('', @fs), "\n");
}

# Part 1: Populate @fs.
my $inline = <>;
chomp($inline);
my @inline = split(//, $inline);

my $pos = 0;
for(my $i=0; $i <= $#inline; $i+=2) {
  $filepos[$i/2] = $pos;
  $filelen[$i/2] = $inline[$i];
  $pos += $inline[$i];
  if($i+1 <= $#inline) {
    $emptypos[$i/2] = $pos;
    $emptylen[$i/2] = $inline[$i+1];
    $pos += $inline[$i+1];
  }
}
$DEBUG && printfs;

# Part 2: Defrag @fs.
for(my $from = $#filepos; $from > 0; $from--) {
  # Find a place for a file's blocks.
  for(my $to=0; $emptypos[$to] < $filepos[$from]; $to++) {
    if($emptylen[$to] >= $filelen[$from]) {
      # Move the file to the empty space.
      $filepos[$from] = $emptypos[$to];
      # Move the empty space after the file and shrink it.  Maybe to zero!
      $emptypos[$to] += $filelen[$from];
      $emptylen[$to] -= $filelen[$from];
      # Move on to the next file.
      last;
    }
  }
  $DEBUG && printfs;
}

# Part 3: Checksum @fs.
my $sum = 0;
for(my $i=0; $i <= $#filepos; $i++) {
  # The checksum for each file looks like the sum of a range of block positions times the file's index number.
  my $l = $filelen[$i];
  $sum += $i * (($l*($l-1))/2 + $filepos[$i]*$l);
}

print $sum, "\n";
