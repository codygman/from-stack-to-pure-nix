{ compilerVersion ? "ghc883" ,
  pkgs ?
  import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs-channels/archive/nixos-20.03.tar.gz";
    sha256 = "1gqv2m7plkladd3va664xyqb962pqs4pizzibvkm1nh0f4rfpxvy";
  }) {}}:
let
  compiler = pkgs.haskell.packages."${compilerVersion}";
  pkg = compiler.developPackage
    { root = ./.;
      # overrides = self: super: {};
      # source-overrides = {};
      modifier = drv:
        pkgs.haskell.lib.overrideCabal drv (old: {
          buildDepends = [ pkgs.cabal-install ];
          preConfigure = builtins.concatStringsSep "\n" [
            (old.preConfigure or "")
            "hpack"
          ];
        });
    };
in pkg
