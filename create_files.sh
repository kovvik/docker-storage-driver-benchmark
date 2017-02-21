#!/bin/bash

DIRS=( "1k" "10k" "1000k" "10000k" )
TEST_DIR=./test

mkdir $TEST_DIR

function create_files() {
  for i in ${DIRS[@]}
  do
    this_dir=$TEST_DIR/$i
    mkdir $this_dir
    for j in {1..100}
    do
      dd if=/dev/zero of=$this_dir/$j bs=$i count=1 &> /dev/null
    done
  done
}

time create_files
