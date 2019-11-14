let
  buildPkgs = import <nixpkgs> { overlays = []; };

  pin = builtins.fromJSON
    (builtins.readFile ./version.json);

  name = "NixOS-QChem";
  version = pin.version;

  nixpkgsSource = buildPkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs-channels";
    inherit (pin.nixpkgs) rev sha256;
  };

  overlaySource = buildPkgs.fetchFromGitHub {
    owner = "markuskowa";
    repo = "NixOS-QChem";
    inherit (pin.NixOS-QChem) rev sha256;
  };

in with buildPkgs; rec {

  # Create the channel structure
  channel = runCommand "channel" {
    inherit version;
    versionsJSON = ./version.json;
    channelNix = ./channel.nix;
  }
  ''
    mkdir -p $out/nixpkgs $out/NixOS-QChem

    cp -r ${nixpkgsSource.outPath}/* $out/nixpkgs
    cp -r ${overlaySource.outPath}/* $out/NixOS-QChem

    cp $versionsJSON $out/versions.json

    cp $channelNix $out/default.nix

    echo "${version}" > $out/nixpkgs/.version
  '';


  # Create nixexprs package for publishing the channel
  nixexprs = runCommand "nixeprs" {
    inherit version;
  } ''

      revNix=`echo ${pin.nixpkgs.rev} | cut -c1-6`
      revQC=`echo ${pin.NixOS-QChem.rev} | cut -c1-6`
      release="${name}-${version}-$revNix-$revQC"
      mkdir -p $release $out

      cp -r ${channel}/* $release/
      tar cavf $out/nixexprs.tar.xz $release
  '';
}
