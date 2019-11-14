let

  pin = builtins.fromJSON (builtins.readFile ./version.json);

  nixpkgsSource = builtins.fetchGit {
    inherit (pin.nixpkgs) url rev;
    ref="nixos-${pin.version}";
  };

  overlaySource = builtins.fetchGit {
    inherit (pin.NixOS-QChem) url rev;
    ref="release-${pin.version}";
  };

in (import nixpkgsSource) { overlays = [ (import overlaySource) ]; }
