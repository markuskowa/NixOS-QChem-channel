#!/usr/bin/env bash

if [ $# -eq 0 ]; then
  echo
  echo "Build and copy channel via scp"
  echo
  echo "Usage `basename $0` <target location>"
  echo
  exit 0
fi

out=`nix-build --no-out-link release.nix -A nixexprs`

scp $out/nixexprs.tar.xz $1

