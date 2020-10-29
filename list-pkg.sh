#!/usr/bin/env bash

echo "-- Check pkgbuild dirs --"

echo "-- Ugly fixme --"

git clone https://github.com/brokenpip3/my-pkgbuild scriptdir
ls -1 scriptdir/pkgbuild > pkg-list 

echo "-- Pkgs: --"

cat pkg-list
