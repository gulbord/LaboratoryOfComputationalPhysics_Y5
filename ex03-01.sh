#!/bin/bash

# create subdir 'students' only if it doesn't exist
mkdir -p students

# download csv list of students if it isn't already there
file=students/LCP_22-23_students.csv
if [ ! -f $file ]; then
    wget -q -O $file \
    https://www.dropbox.com/s/867rtx3az6e9gm8/LCP_22-23_students.csv
fi
# remove DOS line endings
sed -i "s/\r$//" $file

# get filenames
filename=${file%%.*}
podfile=${filename}_PoD.csv
physfile=${filename}_Physics.csv

# add corresponding students
grep "PoD" $file > $podfile
grep "Physics" $file > $physfile

# add header to both files
header=$(head -n 1 $file)
sed -i "1i$header" $podfile $physfile

# count number of surnames starting with a given letter, and find max count
maxcount=1
maxletter=A
for c in {A..Z}; do
    count=$(tail -n+2 $file | grep -c "^$c")
    echo "$c --> $count"
    if [ "$count" -gt "$maxcount" ]; then
        maxcount=$count
        maxletter=$c
    fi
done
echo "The most common first letter in surnames is $maxletter"

# if group files are not present, create them empty
if [[ -n $(echo students/group*) ]]; then
    for i in 0{1..9} {10..18}; do
        touch students/group$i.csv
    done
else
    exit 0
fi

# read student list line by line
count=1
while IFS='' read -r line; do
    # get group number by line mod 18
    groupnum=$(($count % 18))
    if [ "$groupnum" -eq 0 ]; then
        groupnum=18
    fi
    echo $line >> students/group$(printf %02d $groupnum).csv
    count=$(($count + 1))
done < <(tail -n+2 $file)
