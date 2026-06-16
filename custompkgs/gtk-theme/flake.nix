# {
#   stdenvNoCC,
# }:
# stdenvNoCC.mkDerivation {
#   pname = "miku-gtk-theme";
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
        miku-gtk-theme = pkgs.stdenvNoCC.mkDerivation {
          pname = "miku-gtk-theme";
          version = "v0.0";
          src = ./.;
          installPhase = ''
            mkdir -p $out/share/themes/
            cp --archive 'Miku GTK Theme/' $out/share/themes/
          '';
        };
      in
      {
        packages = {
          inherit miku-gtk-theme;
          default = miku-gtk-theme;
        };
      }
    );
}
