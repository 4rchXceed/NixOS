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
        cyan-breeze-dark-icons = pkgs.stdenvNoCC.mkDerivation {
          pname = "cyan-breeze-dark-icons";
          version = "v0.0";
          src = builtins.fetchGit {
            url = "https://github.com/L4ki/Manjaro-Cyan-Plasma-Themes";
            rev = "8043fbc4acc27a9d7d49eb234a7ccc2b9d4a74c0";
          };

          nativeBuildInputs = [
            pkgs.gtk3
          ];

          # https://github.com/NixOS/nixpkgs/blob/nixos-25.11/pkgs/by-name/pa/papirus-icon-theme/package.nix#L56
          installPhase = ''
            runHook preInstall

            mkdir -p "$out/share/icons"
            cp -r Cyan-Breeze-Icons/Cyan-Breeze-Dark-Icons/ "$out/share/icons/"

            for theme in $out/share/icons/*; do
              gtk-update-icon-cache --force $theme
            done

            runHook postInstall
          '';
        };
      in
      {
        packages = {
          inherit cyan-breeze-dark-icons;
          default = cyan-breeze-dark-icons;
        };
      }
    );
}
