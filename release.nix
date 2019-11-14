let
  buildPkgs = import <nixpkgs> { overlays = []; };

  pin = builtins.fromJSON
    (builtins.readFile ./version.json);

  name = "NixOS-QChem";
  version = pin.version;

in with buildPkgs; rec {
  channel = stdenvNoCC.mkDerivation rec {
    inherit name version;

    src = ./.;

    phases = [ "installPhase" ];

    nixpkgsSource = fetchFromGitHub {
      owner = "NixOS";
      repo = "nixpkgs-channels";
      inherit (pin.nixpkgs) rev sha256;
    };

    overlaySource = fetchFromGitHub {
      owner = "markuskowa";
      repo = "NixOS-QChem";
      inherit (pin.NixOS-QChem) rev sha256;
    };

    installPhase = ''
      mkdir -p $out/nixpkgs $out/NixOS-QChem

      cp -r ${nixpkgsSource.outPath}/* $out/nixpkgs
      cp -r ${overlaySource.outPath}/* $out/NixOS-QChem

      cp ${src}/nixpkgs-version.json $out/
      cp ${src}/NixOS-QChem-version.json $out/

      cp ${src}/channel.nix $out/default.nix

      echo "${version}" > $out/nixpkgs/.version
    '';
  };

  nixexprs = runCommand "nixeprs" {
    inherit version;
  } ''

      revNix=`echo ${pinNixpkgs.rev} | cut -c1-6`
      revQC=`echo ${pinNixOS-QChem.rev} | cut -c1-6`
      release="${name}-${version}-$revNix-$revQC"
      mkdir -p $release $out

      cp -r ${channel}/* $release/
      tar cavf $out/nixexprs.tar.xz $release
  '';
}
