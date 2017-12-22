#!/bin/bash

binCount=$(ls -1q ./bins | wc -l | sed -e 's/^[ `t]*//')

echo "Found $binCount bins"

echo "Giving all bins correct permissions (755)..."

for f in ./bins/*
do
  chmod 755 $f
done

echo "Packing the binpack..."

cd $PWD
tar -cf bootstrap.tar ./bins/*

echo "Packed $binCount bins from $PWD/bins into $PWD/bootstrap.tar!"

echo "Please copy the bootstrap.tar file into the Xcode project!"
