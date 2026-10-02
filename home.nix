{
  config,
  pkgs,
  inputs,
  # pake-youtube-music,
  ...
}:
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
      # Proton <3
      protonvpn-gui
      proton-pass
      protonmail-bridge-gui
      # Email
      thunderbird
      # Everyday apps
      discord
      vesktop
      steam
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
      prismlauncher
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
      linvstmanager
      # Auto mgr
      playerctl
      vscode
      obs-cmd
      obs-studio-plugins.obs-websocket
      pkgs.gcr
      kdePackages.kdenlive
      audacity
      openrgb-with-all-plugins
      qFlipper
      qbittorrent
      jetbrains.idea-oss
      gimp-with-plugins
      moonlight-qt
      hyprshade
      winbox
      lsfg-vk
      # Low-latency audio
      (pkgs.callPackage ./custompkgs/thirdparty/pipeasio { })
      floorp-bin
    ]
  );

  services.protonmail-bridge.enable = true;

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

      ZSH_CUSTOM=$HOME/.config/oh-my-zsh

      mkdir -p $HOME/.config/oh-my-zsh

      export WINE_BIN=$(dirname $(readlink $(which wine)))/.wine

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
    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.8.0";
          sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
        };
      }
    ];
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

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
    ];
    config = {
      hyprland = {
        default = [
          "hyprland"
          "gtk"
        ];
        "org.freedesktop.impl.portal.ScreenCast" = [
          "gnome"
        ];
      };
    };
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
      core.autocrlf = true;
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
  # PipeASIO DLL
  home.file.".local/lib/wine".source = mkLink "${
    (pkgs.callPackage ./custompkgs/thirdparty/pipeasio { })
  }/lib/wine";
  # Wine64
  home.file."bin/wine64".source = mkLink "/etc/profiles/per-user/archxceed/bin/wine"; # Clearly not the best way, but it'll prob' work
  # SDDM Wallpaper (not needed, because as root I use /etc/nixos)
  # home.file."Pictures/wp/miku-video.mp4".source = mkLink "${dotfiles}/private/videos/miku-video.mp4";
  # Unused
  # home.file.".config/waybar/scripts/get_ssd_temp.sh".source = mkLink "${dotfiles}/waybar/scripts/get_ssd_temp.sh";

}
