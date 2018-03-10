#!/bin/bash

# This bash script expects to be fed a line-seperated list of numbers and will print out the sum/count/average/medium/min/max encountered.
# based on a script from: https://unix.stackexchange.com/questions/13731/is-there-a-way-to-get-the-min-max-median-and-average-of-a-list-of-numbers-in

sort -n | awk '
  BEGIN {
    c = 0;
    sum = 0;
    OFS="\t";
    print "sum","count", "average", "medium", "min", "max"
  }
  $1 ~ /^[0-9]*(\.[0-9]*)?$/ {
    a[c++] = $1;
    sum += $1;
  }
  END {
    ave = sum / c;
    if( (c % 2) == 1 ) {
      median = a[ int(c/2) ];
    } else {
      median = ( a[c/2] + a[c/2-1] ) / 2;
    }
    print sum, c, ave, median, a[0], a[c-1];
}
'
