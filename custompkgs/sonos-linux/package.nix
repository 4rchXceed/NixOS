# NEEDS "ffmpeg" IN systemPackages TO WORK
{
  pkgs,
}:

let
  source = pkgs.fetchFromGitHub {
    owner = "LuisEGR";
    repo = "sonos-linux";
    rev = "99d70237a0bf85567da48957fd0f269a779f863e";
    sha256 = "sha256-Spb+6uIV4ZSiFu/WyKbffb+aj5eM/eZvJU51iK+ccXk=";
  };
  runtimePackages = with pkgs; [
    pulseaudio
    python3Packages.pygobject3
    python3Packages.gst-python
    ffmpeg
  ];
  buildPackages = with pkgs; [
    go
  ];
in
  pkgs.stdenv.mkDerivation (finalAttrs: {
    pname = "sonos-linux";
    version = "0.1.0";

    src = source;

    buildInputs = runtimePackages;
    nativeBuildInputs = buildPackages ++ runtimePackages ++ [ pkgs.writableTmpDirAsHomeHook ];

    installPhase = ''
      make install DESTDIR=$out

      mkdir -p $out/bin
      ln -s $out/usr/local/lib/sonos-linux/sonos-linux $out/bin/sonos-linux
    '';
})
