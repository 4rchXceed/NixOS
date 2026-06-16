{ config, pkgs, ... }:

let
  dotfiles = "/etc/nixos/dotfiles";
  mkLink = path: config.lib.file.mkOutOfStoreSymlink path;
in
{
  home.stateVersion = "25.11";
  home.username = "archxceed";
  home.homeDirectory = "/home/archxceed";
  programs.home-manager.enable = true;
  services.kdeconnect.enable = true;
  services.kdeconnect.indicator = true;
  home.packages = (
    with pkgs;
    [
      # wayland
      # CLI tools
      git
      btop
      cava
      nixfmt
      # Everyday apps
      discord
      vesktop
      protonvpn-gui
      steam
      vscodium
      obsidian
      blender
      oh-my-zsh
      xfce.thunar
      kdePackages.kate
      nextcloud-client
      nvme-cli
      brave
      vlc
      nmgui
      zed-editor
      pavucontrol
      overskride
      obs-studio
      ryubing
      winboat
      drawio
      # dotnet-sdk_10
      dotnet-sdk_11
      # Rice pkgs (maybe: move to another file)
      waybar
      hyprpaper
      fastfetch
      rofi
      zsh-powerlevel10k
      wlogout
      pamixer
      wl-clipboard
      cliphist
      grim
      slurp
      nil
      nixd
      libreoffice
      # We use this at school
      vmware-workstation
      # More like "utils"
      winetricks
      wineWow64Packages.stagingFull
      # No Wayland support (for now :()
      # wineWow64Packages.waylandFull <- this has Wine v10 ONLY I WANT THE 11
      rustc
      cargo
      rust.packages.stable.rustPlatform.rustcSrc
      # Winboat
      freerdp
      # Art apps
      inkscape
      # MUSIIIIIC
      yabridge
      yabridgectl
      vital
    ]
  );

  services.dunst.enable = true;
  # services.hyprpaper = {
  #   enable = true;
  #   settings = {
  #     preload = [
  #       "~/Pictures/wp/sakura_miku.jpeg"
  #       "~/Pictures/wp/miku_1.jpg"
  #     ];
  #     wallpaper = [
  #       "DP-3,~/Pictures/wp/miku_1.jpg"
  #       "HDMI-A-1,~/Pictures/wp/sakura_miku.jpeg"
  #       "eDP-1,~/Pictures/wp/sakura_miku.jpeg"
  #       ",~/Pictures/wp/sakura_miku.jpeg"
  #     ];
  #   };
  # };
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    initContent = ''
      fastfetch

      POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

      source ~/.p10k.zsh

      alias nixrb="sudo nixos-rebuild switch --flake path:/etc/nixos#ArchXceed"

      export PATH="$PATH:/home/archxceed/bin"
    '';
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "python"
        "node"
        "man"
      ];
    };
  };

  xdg.configFile = {
    # Fastfetch
    "fastfetch/config.jsonc".source = mkLink "${dotfiles}/fastfetch/config.jsonc";
    # Hyprland
    "hypr/hyprland.conf".source = mkLink "${dotfiles}/hypr/hyprland.conf";
    "hypr/hyprpaper.conf".source = mkLink "${dotfiles}/hypr/hyprpaper.conf";
    # Waybar
    "waybar/config.jsonc".source = mkLink "${dotfiles}/waybar/config.jsonc";
    "waybar/style.css".source = mkLink "${dotfiles}/waybar/style.css";
    # Rofi
    "rofi/current.rasi".source = mkLink "${dotfiles}/rofi/current.rasi";
    "rofi/config.rasi".source = mkLink "${dotfiles}/rofi/config.rasi";
    # Wlogout
    "wlogout/style.css".source = mkLink "${dotfiles}/wlogout/style.css";
    "wlogout/layout".source = mkLink "${dotfiles}/wlogout/layout";
    # Kitty
    "kitty/kitty.conf".source = mkLink "${dotfiles}/kitty/kitty.conf";
  };

  # Git
  programs.git = {
    enable = true;
    settings.user = {
      name = "ArchXceed";
      email = "lyam.zambaz@pm.me";
    };
    settings = {
      init.defaultBranch = "master";
      safe.directory = "/etc/nixos";
      credential.helper = "store";
    };
  };

  # Other files
  # Images
  home.file."Pictures/wp/miku_1.jpg".source = mkLink "${dotfiles}/images/miku_1.jpg";
  home.file."Pictures/wp/sakura_miku.jpeg".source = mkLink "${dotfiles}/images/sakura_miku.jpeg";
  home.file."Pictures/wp/neofetch.bg".source = mkLink "${dotfiles}/images/neofetch.bg";
  # Waybar scripts
  home.file.".config/waybar/scripts/update_perf_mode.sh".source =
    mkLink "${dotfiles}/waybar/scripts/update_perf_mode.sh";
  # ZSH
  home.file.".p10k.zsh".source = mkLink "${dotfiles}/.p10k.zsh";
  # Wlogout icons
  home.file.".config/wlogout/icons/hibernate.png".source = mkLink "${dotfiles}/icons/hibernate.png";
  home.file.".config/wlogout/icons/lock.png".source = mkLink "${dotfiles}/icons/lock.png";
  home.file.".config/wlogout/icons/logout.png".source = mkLink "${dotfiles}/icons/logout.png";
  home.file.".config/wlogout/icons/reboot.png".source = mkLink "${dotfiles}/icons/reboot.png";
  home.file.".config/wlogout/icons/shutdown.png".source = mkLink "${dotfiles}/icons/shutdown.png";
  home.file.".config/wlogout/icons/suspend.png".source = mkLink "${dotfiles}/icons/suspend.png";
  # Wine64
  home.file."bin/wine64".source = mkLink "/etc/profiles/per-user/archxceed/bin/wine"; # Clearly not the best way, but it'll prob' work
  # SDDM Wallpaper (not needed, because as root I use /etc/nixos)
  # home.file."Pictures/wp/miku-video.mp4".source = mkLink "${dotfiles}/private/videos/miku-video.mp4";
  # Unused
  # home.file.".config/waybar/scripts/get_ssd_temp.sh".source = mkLink "${dotfiles}/waybar/scripts/get_ssd_temp.sh";

}
