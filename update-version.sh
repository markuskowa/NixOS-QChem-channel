#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-prefetch-git jq

version=19.09

nix-prefetch-git https://github.com/nixos/nixpkgs-channels.git refs/heads/nixos-$version > nixpkgs-version.json
nix-prefetch-git https://github.com/markuskowa/NixOS-QChem.git refs/heads/release-$version > NixOS-QChem-version.json


jq -s ". | { version : \"$version\", nixpkgs : .[0], \"NixOS-QChem\" : .[1] }" \
  nixpkgs-version.json NixOS-QChem-version.json | tee version.json

rm nixpkgs-version.json NixOS-QChem-version.json
