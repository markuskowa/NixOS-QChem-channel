#!/usr/bin/env bash

if [ $# -eq 0 ]; then
  echo
  echo "Build and copy channel"
  echo
  echo "Usage `basename $0` <target location>"
  echo
fi

out=`nix-build --no-out-link release.nix -A channel`

scp $out/nixexprs.tar.xz $1

