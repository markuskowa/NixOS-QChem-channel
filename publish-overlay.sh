#!/usr/bin/env bash

if [ $# -eq 0 ]; then
  echo
  echo "Build and link channel locally"
  echo
  echo "Usage `basename $0` <target location>"
  echo
  exit 0
fi


nix-env -i -f release.nix -A channel -p $1


