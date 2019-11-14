#
# Template for a channel's default.nix
#
{ system ? builtins.currentSystem }:

import ./nixpkgs {
  inherit system;
  overlays = [ (import ./NixOS-QChem) ];
}

