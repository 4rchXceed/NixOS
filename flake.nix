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
    # pake-youtube-music = {
    #   url = "path:custompkgs/pake/YoutubeMusic/";
    # };
    lsfg-vk = {
      url = "github:Daaboulex/lsfg-vk-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vpets = {
      url = "github:furudbat/wayland-vpets";
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
      lsfg-vk,
      vpets,
      # pake-youtube-music,
      ...
    }:
    let

      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      # unstable = import nixpkgs-unstable { inherit system; };
    in
    {
      nixpkgs.overlays = [ inputs.lsfg-vk.overlays.default ];
      nixosConfigurations.ArchXceed = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          # inherit pake-youtube-music;
          inherit inputs;
          # inherit unstable;
        };

        modules = [
          ./configuration.nix
          mikuboot.nixosModules.default
          vpets.nixosModules.default
          {
            programs.wayland-bongocat = {
              enable = true;
              autostart = true;
              inputDevices = [
                "/dev/input/by-id/usb-HP__Inc_HyperX_Alloy_Origins-event-kbd"
              ];
              catYOffset = 0;
              catXOffset = 0;
              extraConfig = ''
                keyboard_device=/dev/input/by-id/usb-HP__Inc_HyperX_Alloy_Origins-event-kbd

                animation_name=custom

                custom_sprite_sheet_filename=/etc/nixos/dotfiles/bongocat/spritesheet.png
                custom_happy_row=2
                custom_writing_frames=2
                custom_sleep_frames=2
                custom_idle_frames=2
                custom_idle_frames=2
                custom_moving_frames=2

                overlay_height=1080

                animation_speed=100
                cat_height=200
                overlay_position=bottom
                cat_align=right
                cat_y_offset=425
                cat_x_offset=5

                monitor=HDMI-A-1
                screen_width=1920

                fps=15
              '';
            };
          }
          home-manager.nixosModules.home-manager

          {
            home-manager.extraSpecialArgs = {
              # inherit pake-youtube-music;
            };

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.archxceed = {

              imports = [
                ./home.nix
                ./configs/neovim.nix
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

            };

          }

          (
            { inputs, pkgs, ... }:
            {
              environment.systemPackages = [
                inputs.waybar-module-music.packages.${pkgs.system}.waybar-module-music
                inputs.lsfg-vk
              ];
            }
          )

        ];
      };
    };
}
