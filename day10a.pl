#!/usr/bin/perl -w
use strict;

my $DEBUG=0;
my $sum = 0;

my @topo;
my @summits;
my $y=1;
while(<>) {
  chomp;
  my $row = '.' . $_ . '.';
  my @row = split(//, $row);
  push @topo, \@row;
  my @summitrow = ( {} );
  for(my $x=1; $x < $#row; $x++) {
    if($row[$x] eq 9) {
      push @summitrow, { "${x}x$y" => 1 };
    } else {
      push @summitrow, { };
    }
  }
  push @summits, \@summitrow;
  $y++;
}
my @sentinel = split(//, '.'x56);
my @summitrow = ( );
for(my $x=0; $x < 56; $x++) {
  push @summitrow, { };
}
push @topo, \@sentinel;
unshift @topo, \@sentinel;
push @summits, \@summitrow;
unshift @summits, \@summitrow;

for(my $layer=8; $layer >= 0; $layer--) {
  for(my $y=1; $y < $#topo; $y++) {
    for(my $x=1; $x < $#{$topo[$y]}; $x++) {
      if($topo[$y]->[$x] eq $layer) {
        if($topo[$y]->[$x-1] eq ($layer+1)) {
          $summits[$y]->[$x] = { %{$summits[$y]->[$x]}, %{$summits[$y]->[$x-1]} };
        }
        if($topo[$y]->[$x+1] eq ($layer+1)) {
          $summits[$y]->[$x] = { %{$summits[$y]->[$x]}, %{$summits[$y]->[$x+1]} };
        }
        if($topo[$y-1]->[$x] eq ($layer+1)) {
          $summits[$y]->[$x] = { %{$summits[$y]->[$x]}, %{$summits[$y-1]->[$x]} };
        }
        if($topo[$y+1]->[$x] eq ($layer+1)) {
          $summits[$y]->[$x] = { %{$summits[$y]->[$x]}, %{$summits[$y+1]->[$x]} };
        }
        if($layer == 0) {
          #print join(';', keys(%{$summits[$y]->[$x]})), "\n" if $DEBUG;
          print scalar(keys(%{$summits[$y]->[$x]})), ", " if $DEBUG;
          $sum += scalar(keys(%{$summits[$y]->[$x]}));
        }
      }
    }
  }
}

print $sum, "\n";
