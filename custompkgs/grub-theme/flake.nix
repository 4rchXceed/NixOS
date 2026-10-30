# {
#   stdenvNoCC,
# }:
# stdenvNoCC.mkDerivation {
#   pname = "miku-grub-theme";
#   version = "v0.0";
#   src = ./.;
#   installPhase = ''
#     mkdir -p $out/share/themes/
#     cp --archive 'Miku GTK Theme/' $out/share/themes/
#   '';
# };
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      utils,
      nixpkgs,
      ...
    }:
    let
      inherit (utils.lib) eachDefaultSystem;
    in
    eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        miku-grub-theme = pkgs.stdenvNoCC.mkDerivation {
          pname = "miku-grub-theme";
          version = "v0.0";
          src = builtins.fetchGit {
            url = "https://github.com/yorunoken/HatsuneMiku";
            rev = "72735faca036d7e129cb7d2181b3d18b90eaf069";
          };
          installPhase = ''
            cp -r '4k-HatsuneMiku' $out
          '';
        };
      in
      {
        packages = {
          inherit miku-grub-theme;
          default = miku-grub-theme;
        };
      }
    );
}
