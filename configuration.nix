# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

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
  ];
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchDocked = "ignore";
    HandlePowerKey = "ignore";
  };
  services.logind.settings.Login.HandleLidSwitchExternalPower = "ignore";
  services.blueman.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = false;
  boot.supportedFilesystems = [ "ntfs" ];
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

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.systemd.enable = true;
  boot.initrd.luks.devices."luks-2b12aa91-cef7-48f6-a764-7d6884d3b9f0".device =
    "/dev/disk/by-uuid/2b12aa91-cef7-48f6-a764-7d6884d3b9f0";

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
  services.flatpak.enable = true;
  # ------------ Added config ---------------
  # Main DE
  programs.hyprland.enable = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  networking.networkmanager.enable = true;
  #networking.useDHCP = true;
  networking.hostName = "mikumikulovelaptop";
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
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
    polkit.enable = true;
    rtkit.enable = true;
    pam = {
      services = {
        kwallet = {
          name = "kwallet";
          enable = false;
        };
      };
    };
  };
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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # BAD, BUT REQUIRED FOR ZED EXTENSIONS:
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    openssl
    curl
    # Renpy games
    libGL
    libsForQt5.polkit-qt
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.archxceed = {
    isNormalUser = true;
    description = "ArchXceed";
    extraGroups = [
      "networkmanager"
      "wheel"
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
    linux-wifi-hotspot
    haveged
  ];
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Run a DHCP server on the downstream interface
  networking.firewall.extraCommands = ''
    # Set up SNAT on packets going from downstream to the wider internet
    iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE

    # Accept all connections from downstream. May not be necessary
    iptables -A INPUT -i enp2s0 -j ACCEPT
  '';
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  services.usbmuxd.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;
  programs.appimage.package = pkgs.appimage-run.override {
    extraPkgs = pkgs: [
      pkgs.icu
      pkgs.libxcrypt-legacy
      pkgs.python312
    ];
  };
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  services.ollama = {
    enable = true;
    host = "0.0.0.0";
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  virtualisation.docker.enable = true;
  # virtualisation.vmware.host.enable = true;
  virtualisation.libvirtd = {
    enable = true;
  };
  programs.virt-manager.enable = true;
  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    22
    8000
    8080
    5901
    3923
    2869
    1900
    5001
  ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
