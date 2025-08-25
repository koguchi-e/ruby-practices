#!/bin/bash

echo "==== file1.txt ===="
./wc.rb file1.txt
wc file1.txt

echo "==== file1.txt file2.txt ===="
./wc.rb file1.txt file2.txt
wc file1.txt file2.txt

echo "==== -l file1.txt ===="
./wc.rb -l file1.txt
wc -l file1.txt

echo "==== -wc file1.txt file2.txt ===="
./wc.rb -wc file1.txt file2.txt
wc -wc file1.txt file2.txt

echo "==== ls.rb -l | wc.rb ===="
../04.ls/ls.rb -l | ./wc.rb
ls -l | wc
