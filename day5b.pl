#!/usr/bin/perl -w
use strict;

my $sum = 0;
my $count = 0;
my $DEBUG = 0;
my %toblacklist;

while(<>) {
  chomp;
  last if /^$/;
  die "Invalid line $_" unless /^([0-9]+)\|([0-9]+)$/;
  # If the second entry is seen, the first entry must not subsequently be seen.
  my $page1 = $1;
  my $page2 = $2;
  # Bug: a new blacklist entry should append to an older one, not overwrite it!
  $toblacklist{$page2} = [] if(!exists($toblacklist{$page2}));
  push @{$toblacklist{$page2}}, $page1;
  $DEBUG && print "Page $page1 blacklisted after seeing page $page2\n";
}

while(<>) {
  chomp;
  next if /^$/;
  my @update = split(/,/);
  $DEBUG && print join(',', @update), "\n";
  my $valid = 1;
  my $fixed = 0;
  while($fixed == 0) {
    my %blacklist = ();
    $fixed = 1;
    for(my $i=0; $i <= $#update; $i++) {
      my $page = $update[$i];
      if(exists($blacklist{$page})) {
        $valid = 0;
        $fixed = 0;
        $DEBUG && print join(',', @update), ": Page $page was blacklisted\n";
        # Now exchange this entry for the previous one.
        # There must be a previous one because %blacklist is empty at the start.
        $update[$i] = $update[$i-1];
        $update[$i-1] = $page;
        last;
      }
      $DEBUG && print "$page is valid here\n";
      if(exists($toblacklist{$page})) {
        foreach my $newbl (@{$toblacklist{$page}}) {
          $blacklist{$newbl} = 1;
          $DEBUG && print "Blacklisting page $newbl in future\n";
        }
      }
    }
  }
  next if $valid;
  $count++;
  $sum += $update[$#update/2];
}
print $count, " updates are fixed.\n";
print $sum, "\n";
