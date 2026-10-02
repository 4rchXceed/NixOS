{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  # --- Fonts ---
  fonts.fontconfig.enable = true;
  fonts.packages = with pkgs; [
    noto-fonts-monochrome-emoji
    cascadia-code
    # JP <3
    ipafont
    kochi-substitute
  ];
}
