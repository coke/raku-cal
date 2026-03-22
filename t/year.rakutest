#!/usr/bin/env raku

=begin comment

Test that our output for a given month matches system cal

=end comment

use Test;
use Test::Differences;

plan 1;

# Output from system cal
my $y2022 = q:to/CAL/;
                            2022
      January               February               March          
Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa  
                   1         1  2  3  4  5         1  2  3  4  5  
 2  3  4  5  6  7  8   6  7  8  9 10 11 12   6  7  8  9 10 11 12  
 9 10 11 12 13 14 15  13 14 15 16 17 18 19  13 14 15 16 17 18 19  
16 17 18 19 20 21 22  20 21 22 23 24 25 26  20 21 22 23 24 25 26  
23 24 25 26 27 28 29  27 28                 27 28 29 30 31        
30 31                                                             

       April                  May                   June          
Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa  
                1  2   1  2  3  4  5  6  7            1  2  3  4  
 3  4  5  6  7  8  9   8  9 10 11 12 13 14   5  6  7  8  9 10 11  
10 11 12 13 14 15 16  15 16 17 18 19 20 21  12 13 14 15 16 17 18  
17 18 19 20 21 22 23  22 23 24 25 26 27 28  19 20 21 22 23 24 25  
24 25 26 27 28 29 30  29 30 31              26 27 28 29 30        
                                                                  

        July                 August              September        
Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa  
                1  2      1  2  3  4  5  6               1  2  3  
 3  4  5  6  7  8  9   7  8  9 10 11 12 13   4  5  6  7  8  9 10  
10 11 12 13 14 15 16  14 15 16 17 18 19 20  11 12 13 14 15 16 17  
17 18 19 20 21 22 23  21 22 23 24 25 26 27  18 19 20 21 22 23 24  
24 25 26 27 28 29 30  28 29 30 31           25 26 27 28 29 30     
31                                                                

      October               November              December        
Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa  
                   1         1  2  3  4  5               1  2  3  
 2  3  4  5  6  7  8   6  7  8  9 10 11 12   4  5  6  7  8  9 10  
 9 10 11 12 13 14 15  13 14 15 16 17 18 19  11 12 13 14 15 16 17  
16 17 18 19 20 21 22  20 21 22 23 24 25 26  18 19 20 21 22 23 24  
23 24 25 26 27 28 29  27 28 29 30           25 26 27 28 29 30 31  
30 31                                                             
CAL

my $proc=run(<raku -Ilib bin/cal -h 2022>, :out);
my $output=$proc.out.slurp(:close);

# Strip trailing whitespace
$y2022 ~~ s:g/\s+$$//;

# Ignore spacing 
$y2022  ~~ s:g/\s+/ /;
$output ~~ s:g/\s+/ /;

eq_or_diff $output, $y2022, "expected result for non-higlighted year"; 
