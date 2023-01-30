#!/bin/bash

# remove metadata
sed "/^#/d" data.csv > data.txt
# remove spaces after commas
sed -i "s/, /,/g" data.txt

# read numbers and check if they are even, and the other given condition
even=0
gtsqrt=0
ltsqrt=0
# for grouping numbers by three
count=0
sum=0
while IFS=',' read -a nums; do # read numbers in array
    for n in ${nums[@]}; do # loop through array
        ((count += 1))
        if [ $((n % 2)) -eq 0 ]; then
            ((even += 1))
        fi 
        ((sum += n * n))
        if [ $count -eq 3 ]; then
            if [ $sum -gt 7500 ]; then
                ((gtsqrt += 1))
            else
                ((ltsqrt += 1))
            fi
            sum=0
            count=0
        fi
    done
done < data.txt

echo "There are $even even numbers"
echo "There are $gtsqrt entries with sqrt(X^2 + Y^2 + Z^2) > 50 * sqrt(3)"
echo "There are $ltsqrt entries with sqrt(X^2 + Y^2 + Z^2) <= 50 * sqrt(3)"

while IFS=',' read -a nums; do # read numbers in array
    for numfile in $(seq 1 $1); do # loop from 1 to input number
        touch data$(printf %02d $numfile).txt
        for num in ${nums[@]}; do
            echo $((num / numfile)) >> data$(printf %02d $numfile).txt
        done
    done
done < data.txt
