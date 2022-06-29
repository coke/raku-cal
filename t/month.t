#!/usr/bin/env raku

=begin comment

Test that our output for a given month matches system cal

=end comment

use Test;
use Test::Differences;

# Output from system cal
my $june = q:to/CAL/;
     June 2022        
Su Mo Tu We Th Fr Sa  
          1  2  3  4  
 5  6  7  8  9 10 11  
12 13 14 15 16 17 18  
19 20 21 22 23 24 25  
26 27 28 29 30        
CAL

# Strip trailing whitespace
$june ~~ s:g/\s+$$//;

my $proc=run(<raku -Ilib bin/cal -h 6 2022>, :out);
my $output=$proc.out.slurp(:close);

eq_or_diff $output,$june, "expected result for non-higlighted month"; 
