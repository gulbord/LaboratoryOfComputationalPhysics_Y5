#!/bin/bash

# remove metadata
sed "/^#/d" data.csv > data.txt
# remove spaces after commas
sed -i "s/, /,/g" data.txt

# read numbers and check if they are even
while IFS='' read -r line; do
    while IFS=',' read -r num; do
done < data.txt
