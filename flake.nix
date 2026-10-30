{
  description = "ArchXceed flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    waybar-module-music = {
      url = "github:Andeskjerf/waybar-module-music";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    silentSDDM = {
      url = "github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mikuboot = {
      url = "gitlab:evysgarden/mikuboot";
      inputs.nixpkgs.follows = ""; # only useful for the package output
    };
    miku-gtk-theme = {
      url = "path:custompkgs/gtk-theme/";
    };
    miku-grub-theme = {
      url = "path:custompkgs/grub-theme/";
    };
    cyan-breeze-dark-icons = {
      url = "path:custompkgs/cyan-breeze-dark-icons-nix/";
    };
    csakura = {
      url = "github:realstrawhat/csakura";
    };
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
    };
    flake-utils.url = "github:numtide/flake-utils";

    nix-photogimp3 = {
      url = "github:3nol/nix-photogimp3";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    limusic = {
      url = "github:davidvanderklay/limusic-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      waybar-module-music,
      hyprland,
      mikuboot,
      miku-gtk-theme,
      miku-grub-theme,
      cyan-breeze-dark-icons,
      nix-gaming,
      csakura,
      nix-photogimp3,
      ...
    }:
    let

      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      # unstable = import nixpkgs-unstable { inherit system; };
    in
    {

      nixosConfigurations.ArchXceed = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          # inherit unstable;
        };

        modules = [
          ./configuration.nix
          mikuboot.nixosModules.default

          home-manager.nixosModules.home-manager

          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.archxceed = {
              imports = [
                ./configs/neovim.nix
                ./home.nix
              ];
              wayland.windowManager.hyprland = {
                enable = true;
                xwayland.enable = true;
                package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
              };
              xdg.configFile."fontconfig/conf.d/10-hm-fonts.conf".force = true;
              gtk = {
                enable = true;
                theme = {
                  name = "Miku GTK Theme";
                  package = inputs.miku-gtk-theme.packages.${pkgs.system}.default;
                };
                iconTheme = {
                  package = inputs.cyan-breeze-dark-icons.packages.${pkgs.system}.default;
                  name = "Cyan-Breeze-Dark-Icons";
                };
              };
            };
          }

          (
            { inputs, pkgs, ... }:
            {
              environment.systemPackages = [
                inputs.waybar-module-music.packages.${pkgs.system}.waybar-module-music
                csakura.packages.${pkgs.stdenv.hostPlatform.system}.csakura
                nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.osu-lazer-bin
                nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.osu-stable
                inputs.nix-photogimp3.packages.${pkgs.system}.default
                inputs.limusic.packages.${pkgs.system}.limusic
              ];
            }
          )
        ];
      };
    };
}
