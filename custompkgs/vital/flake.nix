# Vital but with VST explosed (see home.nix for how I implemented it)
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      utils,
      nixpkgs,
      ...
    }:
    let
      inherit (utils.lib) eachDefaultSystem;
    in
    eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        icon = pkgs.fetchurl {
          url = "https://vital.audio/images/apple_touch_icon.png";
          hash = "sha256-NZ/AQ2gjBXUPUj3ITbowD7HuxRmEDuATOWidLqLNrww=";
        };
        vital-with-vst = pkgs.stdenv.mkDerivation (finalAttrs: {
          pname = "vital";
          version = "1.5.5";

          src = pkgs.fetchzip {
            url = "https://builds.vital.audio/VitalAudio/vital/${
              builtins.replaceStrings [ "." ] [ "_" ] finalAttrs.version
            }/VitalInstaller.zip";
            hash = "sha256-hCwXSUiBB0YpQ1oN6adLprwAoel6f72tBG5fEb61OCI=";
          };
          desktopItems = [
            (pkgs.makeDesktopItem {
              type = "Application";
              name = "vital";
              desktopName = "Vital";
              comment = "Spectral warping wavetable synth";
              icon = "Vital";
              exec = "Vital";
              categories = [
                "Audio"
                "AudioVideo"
              ];
            })
          ];

          nativeBuildInputs = with pkgs; [
            autoPatchelfHook
            makeBinaryWrapper
            copyDesktopItems
            imagemagick
          ];

          buildInputs = with pkgs; [
            alsa-lib
            libGL
            libsm
            libice
            libx11
            freetype
            libjack2
          ];

          dontBuild = true;

          installPhase = ''
            runHook preInstall

            mkdir -p $out/share/icons/hicolor/128x128/apps
            magick ${icon} -resize 128x128 $out/share/icons/hicolor/128x128/apps/Vital.png

            mkdir -p $out/{bin,lib/{clap,vst,vst3}}
            for f in bin/Vital lib/{clap/Vital.clap,vst/Vital.so,vst3/Vital.vst3}; do
              cp -r $f $out/$f
            done

            wrapProgram $out/bin/Vital \
            --prefix LD_LIBRARY_PATH : "${
              pkgs.lib.makeLibraryPath [
                pkgs.curl
                pkgs.libjack2
              ]
            }" \
            --prefix PATH : "${
              pkgs.lib.makeBinPath [
                pkgs.zenity
              ]
            }"
            runHook postInstall
          '';

          meta = {
            description = "Spectral warping wavetable synth";
            homepage = "https://vital.audio/";
            sourceProvenance = [ pkgs.lib.sourceTypes.binaryNativeCode ];
            # license = pkgs.lib.licenses.unfree; # https://vital.audio/eula/
            platforms = [ "x86_64-linux" ];
            mainProgram = "Vital";
          };
        });
      in
      {
        packages = {
          inherit vital-with-vst;
          default = vital-with-vst;
        };
      }
    );
}
