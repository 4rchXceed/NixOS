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

    vital-with-vst = {
      url = "path:custompkgs/vital/";
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
      vital-with-vst,
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
                ./home.nix
              ];

              wayland.windowManager.hyprland = {
                enable = true;
                xwayland.enable = true;
                package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
                portalPackage =
                  inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
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
              home.file.".vst3/Vital.vst3".source = "${
                inputs.vital-with-vst.packages.${pkgs.system}.default
              }/lib/vst3/Vital.vst3";
              home.file.".vst/Vital.dll".source = "${
                inputs.vital-with-vst.packages.${pkgs.system}.default
              }/lib/vst/Vital.so";

            };

          }

          (
            { inputs, pkgs, ... }:
            {
              environment.systemPackages = [
                inputs.waybar-module-music.packages.${pkgs.system}.waybar-module-music
                # VSTs
                vital-with-vst.packages.${pkgs.system}.default
              ];
            }
          )

        ];
      };
    };
}
