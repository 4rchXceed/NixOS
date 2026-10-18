{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./fonts.nix
    inputs.silentSDDM.nixosModules.default
    ./custompkgs/musnix
  ];

  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb-with-all-plugins;
    server.port = 6742;
  };

  musnix.enable = true;
  services.logind.settings.Login.HandleLidSwitchExternalPower = "ignore";
  services.blueman.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = false;

  boot.loader = {
    grub = {
      enable = true;
      device = "nodev";
      useOSProber = true;
      efiSupport = true;
      theme = inputs.miku-grub-theme.packages.${pkgs.system}.default;
    };

    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  };

  # Slopvidia
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;

    powerManagement.enable = false;

    open = false;

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.kernelModules = [
    "nvidia"
    "nvidia_modeset"
    "nvidia_drm"
    "nvidia_uvm"
    "xhci_pci"
    "ahci"
    "nvme"
    "usbhid"
    "uas"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.systemd.enable = true;
  boot.supportedFilesystems = [ "ntfs" ];

  services.flatpak.enable = true;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking

  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  # services.xserver.enable = true;
  #
  programs.xwayland.enable = true;

  # Steammmmmmm
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # Enable the KDE Plasma Desktop Environment.
  services.desktopManager.plasma6.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  # ------------ Added config ---------------
  # Main DE
  programs.hyprland.enable = true;
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    cores = 0; # Use all cores

    max-jobs = "auto";
  };
  networking.networkmanager.enable = true;
  #networking.useDHCP = true;
  networking.hostName = "mikumikulovelaptop";
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  networking.networkmanager.insertNameservers = [
    "1.1.1.1"
    "8.8.8.8"
  ];
  # ----------- End of addded config -------

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "ch";
    variant = "fr";
  };

  services.displayManager.sddm = {
    enable = true;

    # Enables experimental Wayland support
    wayland.enable = true;
  };

  # Power control for laptops:
  services.power-profiles-daemon.enable = true;

  # Configure console keymap
  console.keyMap = "fr_CH";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  programs.zsh.enable = true;
  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security = {
    rtkit.enable = true;
    pam = {
      services = {
      };
    };
    polkit.enable = true;
  };
  security.pam.services.sddm.enableGnomeKeyring = true;
  services.gnome.gnome-keyring.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  programs.dconf.enable = true;
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # BAD, BUT REQUIRED FOR ZED EXTENSIONS:
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    openssl
    curl
    # For LinVst3
    gtk3
    pango
    atk
    cairo
    gdk-pixbuf
    glib
    gobject-introspection
  ];

  services.usbmuxd.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.archxceed = {
    isNormalUser = true;
    description = "ArchXceed";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "libvirtd"
      "audio"
    ];
    packages = with pkgs; [
      kdePackages.kate
      #  thunderbird
    ];
    shell = pkgs.zsh;
  };
  programs.silentSDDM = {
    enable = true;
    theme = "default";
    backgrounds = {
      miku-video = ./private/videos/miku-video.mp4;
    };
    settings = {
      LoginScreen = {
        background = "miku-video.mp4";
      };
      LockScreen = {
        background = "miku-video.mp4";
      };
    };
  };
  boot.plymouth = {
    enable = true;

    # add theme package and name
    themePackages = [ pkgs.mikuboot ];
    theme = "mikuboot";
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    pkgs.kitty
    pkgs.busybox
    kdePackages.qtmultimedia
    pulseaudio
    # Vulkan
    vulkan-tools
    vulkan-loader
    # CUDA (Can be useful for *some* apps)
    (mlt.override { config.cudaSupport = true; })
    # Virtual Machine Manager
    virt-manager
    # Polkit
    libsForQt5.polkit-qt
    dnsmasq
    gsettings-desktop-schemas
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    gst_all_1.gst-vaapi
  ];
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.variables = {
    GST_PLUGIN_PATH = "/run/current-system/sw/lib/gstreamer-1.0/";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    firewallBackend = "iptables";
  };
  virtualisation.docker.enable = true;
  virtualisation.docker.enableOnBoot = true;
  virtualisation.vmware.host.enable = true;
  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    22
    24444
    25565
  ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
