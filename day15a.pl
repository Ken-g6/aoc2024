#!/usr/bin/perl -w
use strict;
#use Math::Vector::Real;
use experimental 'switch';

my $sum = 0;
my $DEBUG=0;
my @matrix;

# Given an array of arrays of chars, mirror diagonally to rows of strings.
# n
#w.e
# s
#transpose:
# w
#n.s
# e
sub transpose {
  my @oldrows = @_;
  my $width = length($oldrows[0]);
  my @rows;
  for(my $j=0; $j <= $#oldrows; $j++) {
    $oldrows[$j] = [ split(//, $oldrows[$j]) ];
  }
  for(my $i=0; $i < $width; $i++) {
    my @newrow;
    for(my $j=0; $j <= $#oldrows; $j++) {
      $newrow[$j] = $oldrows[$j][$i];
    }
    push @rows, join('', @newrow);
  }
  return @rows;
}

sub printmat {
  $DEBUG || return;
  #print "\033[2J";    #clear the screen
  #print "\033[0;0H"; #jump to 0,0
  print "$_[0]\n";
  foreach my $row (@matrix) {
    print "$row\n";
  }
  #system("sleep 1");
}

my $atrow = -1;
my $atcol = -1;
my $y=0;
while(<>) {
  chomp;
  last if /^$/;
  /^[#O@.]*$/ || die "Invalid input $_";
  push @matrix, $_;
  if(/^([^@]*)@/) {
    $atrow = $y;
    $atcol = length($1);
  }
  $y++;
}

my $iteration = 0;
printmat("Iteration $iteration");
while(<>) {
  chomp;
  /^[<>v\^]*$/ || die "Invalid input $_";
  my @instr = split(//);
  foreach my $vector (@instr) {
    given($vector) {
      when('<') {
        if($matrix[$atrow] =~ s/\.(O*)\@/$1\@./) {
          $atcol--;
        }
      }
      when('>') {
        if($matrix[$atrow] =~ s/\@(O*)\./.\@$1/) {
          $atcol++;
        }
      }
      when('^') {
        # Transposed, up is left
        @matrix = transpose(@matrix);
        if($matrix[$atcol] =~ s/\.(O*)\@/$1\@./) {
          $atrow--;
        }
        @matrix = transpose(@matrix);
      }
      when('v') {
        # Transposed, down is right
        @matrix = transpose(@matrix);
        if($matrix[$atcol] =~ s/\@(O*)\./.\@$1/) {
          $atrow++;
        }
        @matrix = transpose(@matrix);
      }
      default {
        warn "Invalid movement code $vector";
      }
    }
    $iteration++;
    printmat("Iteration $iteration");
  }
}

$y=0;
foreach my $row (@matrix) {
  my @row = split(//, $row);
  my $x = 0;
  foreach my $c (@row) {
    if($c eq 'O') {
      my $gps = 100*$y + $x;
      $DEBUG && print "Box at ($x, $y) = $gps\n";
      $sum += $gps;
    }
    $x++;
  }
  $y++;
}

print $sum, "\n";
