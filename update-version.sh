#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-prefetch-git jq

version=19.09

if [ "$1" == "-h" ]; then
  echo
  echo "Update nixpkgs and NixOS-QChem versions"
  echo
  echo "Base version: $version"
  echo
  echo "Usage: `basename $0` <-a|-q>"
  exit
fi

updateNixpkgs=0

if [ "$1" == "-a" ]; then
  updateNixpkgs=1
fi

nix-prefetch-git https://github.com/markuskowa/NixOS-QChem.git refs/heads/release-$version > NixOS-QChem-version.json


if [ $updateNixpkgs -eq 1 ]; then
  nix-prefetch-git https://github.com/nixos/nixpkgs-channels.git refs/heads/nixos-$version > nixpkgs-version.json
  jq -s ". | { version : \"$version\", nixpkgs : .[0], \"NixOS-QChem\" : .[1] }" \
    nixpkgs-version.json NixOS-QChem-version.json | tee version.json
else
  jq ".nixpkgs" version.json > nixpkgs-version.json
fi

jq -s ". | { version : \"$version\", nixpkgs : .[0], \"NixOS-QChem\" : .[1] }" \
  nixpkgs-version.json NixOS-QChem-version.json | tee version.json


rm nixpkgs-version.json NixOS-QChem-version.json
