#!/usr/bin/perl -w
use strict;
#use Math::Vector::Real;
use experimental 'switch';

my $sum = 0;
my $DEBUG=0;
my @matrix;
my $atrow = -1;
my $atcol = -1;

# Given an array of arrays of chars, mirror diagonally to rows of strings.
sub shiftup {
  my @rows;
  for(my $j=0; $j <= $#matrix; $j++) {
    $rows[$j] = [ split(//, $matrix[$j]) ];
  }

  if(reshiftup(\@rows, $atcol, $atrow)) {
    for(my $j=0; $j <= $#matrix; $j++) {
      $matrix[$j] = join('', @{$rows[$j]});
    }
    $atrow--;
    return 1;
  } else {
    return 0;
  }
}

# Recursive part of shifting up.
sub reshiftup {
  my ( $rows, $x, $y ) = @_;

  my $above = $$rows[$y-1][$x];

  # Return 0 if hit a wall.
  return 0 if($above eq '#');

  if($above eq '.' ||
    ($above eq ']' && reshiftup($rows, $x, $y-1) && reshiftup($rows, $x-1, $y-1)) ||
    ($above eq '[' && reshiftup($rows, $x, $y-1) && reshiftup($rows, $x+1, $y-1))
  ) {
    $$rows[$y-1][$x] = $$rows[$y][$x];
    $$rows[$y][$x] = '.';
    return 1;
  } else {
    return 0;
  }
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

my $y=0;
while(<>) {
  chomp;
  last if /^$/;
  /^[#O@.]*$/ || die "Invalid input $_";
  my $row = $_;
  $row =~ s/([#\.])/$1$1/g;
  $row =~ s/O/[]/g;
  $row =~ s/\@/\@./;
  push @matrix, $row;
  if($row =~ /^([^@]*)@/) {
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
        if($matrix[$atrow] =~ s/\.([\[\]]*)\@/$1\@./) {
          $atcol--;
        }
      }
      when('>') {
        if($matrix[$atrow] =~ s/\@([\[\]]*)\./.\@$1/) {
          $atcol++;
        }
      }
      when('^') {
        shiftup();
      }
      when('v') {
        @matrix = reverse(@matrix);
        $atrow = $#matrix - $atrow;
        shiftup();
        @matrix = reverse(@matrix);
        $atrow = $#matrix - $atrow;
      }
      default {
        warn "Invalid movement code $vector";
      }
    }
    $iteration++;
    printmat("Iteration $iteration, $vector");
  }
}

$y=0;
foreach my $row (@matrix) {
  my @row = split(//, $row);
  my $x = 0;
  foreach my $c (@row) {
    if($c eq '[') {
      my $gps = 100*$y + $x;
      $DEBUG && print "Box at ($x, $y) = $gps\n";
      $sum += $gps;
    }
    $x++;
  }
  $y++;
}

print $sum, "\n";
