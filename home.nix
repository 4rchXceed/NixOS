{
  config,
  pkgs,
  inputs,
  ...
}:

let
  dotfiles = "/etc/nixos/dotfiles";
  mkLink = path: config.lib.file.mkOutOfStoreSymlink path;
  wineAudio = pkgs.wineWow64Packages.full.overrideAttrs (old: {
    src = pkgs.fetchFromGitHub {
      owner = "giang17";
      repo = "wine";
      rev = "eb72ef008555348bf114e5da64c0d8868c46f49a";
      hash = "sha256-Hedf6gZirV6DtsV39gVe/L0oZ93PmFdkLOU61yHVmBE=";
    };
  });
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
      # VMs
      vmware-workstation
      # wayland
      # CLI tools
      git
      btop
      cava
      nixfmt
      # Everyday apps
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
      vlc
      nmgui
      zed-editor-fhs
      pavucontrol
      overskride
      qbittorrent
      drawio
      libreoffice
      brave
      # Rice pkgs (maybe: move to another file)
      waybar
      fastfetch
      rofi
      hyprpaper
      zsh-powerlevel10k
      wlogout
      pamixer
      wl-clipboard
      cliphist
      grim
      slurp
      # Programming Languages [required for zed-editor-fhs]
      rustup
      nil
      nixd
      # More like "utils"
      winetricks
      wineWow64Packages.stagingFull
      jetbrains.idea
      prismlauncher
      vital
      qFlipper
      mpv
      kdePackages.filelight
      nix-index
      nodejs
    ]
  );

  programs.obs-studio = {
    enable = true;
    plugins = [
    ];
  };

  services.dunst.enable = true;
  services.hyprpaper = {
    enable = true;
    # settings = {
    #   preload = [
    #     "~/Pictures/wp/sakura_miku.jpeg"
    #     "~/Pictures/wp/miku_1.jpg"
    #   ];
    #   wallpaper = [
    #     "DP-3,~/Pictures/wp/miku_1.jpg"
    #     "HDMI-A-1,~/Pictures/wp/sakura_miku.jpeg"
    #     "eDP-1,~/Pictures/wp/sakura_miku.jpeg"
    #     ",~/Pictures/wp/sakura_miku.jpeg"
    #   ];
    # };
  };

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

      WINE_BIN=$(dirname $(readlink $(which wine)))/.wine

      export PATH="/home/archxceed/.local/bin:$PATH"

      editor() {
        cd "$1"
        nvim
      }

      alias nixedit="cd /etc/nixos && nvim"
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
      core.autocrlf = true;
      safe.directory = "/etc/nixos";
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
  # SDDM Wallpaper (not needed, because as root I use /etc/nixos)
  # home.file."Pictures/wp/miku-video.mp4".source = mkLink "${dotfiles}/private/videos/miku-video.mp4";
  # Unused
  # home.file.".config/waybar/scripts/get_ssd_temp.sh".source = mkLink "${dotfiles}/waybar/scripts/get_ssd_temp.sh";
  home.file."wine-audio".source = mkLink wineAudio;
}
