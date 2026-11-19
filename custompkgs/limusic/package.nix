{
  lib,
  stdenv,
  rustPlatform,
  cargo-tauri,
  glib-networking,
  nodejs,
  pnpmConfigHook,
  openssl,
  pkg-config,
  webkitgtk_4_1,
  wrapGAppsHook4,
  pkgs,
}:

let
  rustyV8Archive = pkgs.fetchurl {
    url = "https://github.com/denoland/rusty_v8/releases/download/v130.0.7/librusty_v8_release_x86_64-unknown-linux-gnu.a.gz";
    hash = "sha256-pkdsuU6bAkcIHEZUJOt5PXdzK424CEgTLXjLtQ80t10=";
  };
  linderaIpadicFile = pkgs.fetchurl {
    url = "https://github.com/lindera-morphology/mecab-ipadic/archive/refs/tags/2.7.0-20070801.tar.gz";
    hash = "sha256-CZ5G6A1V58DWkGeDr/cTdI4a6Q9Gxe+W7BU7vwm/VVA=";
  };
 linderaIpadicSrc = pkgs.applyPatches {
   src = pkgs.runCommand "lindera-ipadic-src-extract" {} ''
       mkdir -p $out
       chmod -R u+w $out
       tar -xf ${pkgs.fetchurl {
         url = "https://static.crates.io/crates/lindera-ipadic/0.30.0/download";
          hash = "sha256-Ep7BY2Y1SZj5eRRnrThzFTkZd0f2SeVz6thFNYJxziU=";
       }} -C $out --strip-components=1;
   '';
   patches = [ ./lindera-ipadic-0.30.0.patch ];
 };
 limusicSrc = pkgs.runCommand "limusic-src" {} ''
   cp -r ${pkgs.applyPatches {
     src = pkgs.fetchFromGitHub {
       owner = "SimoHypers";
       repo = "limusic";
       rev = "21f3403ed1b317f89c2e057a14d4670b888c20e8";
       sha256 = "sha256-0Uja6fGjiVY2ttsHA0EQI/GLytcxNog39NhsL8ntqYY==";
     };
     patches = [./limusic-lindera-ipadic.patch];
   }} $out

   chmod -R u+w $out
   cp ${./Cargo.lock} $out/src-tauri/Cargo.lock
   cp ${./Cargo.lock} $out/Cargo.lock

   cp -r ${linderaIpadicSrc} $out/src-tauri/lindera-ipadic
 '';
in
rustPlatform.buildRustPackage (finalAttrs: {
  src = limusicSrc;

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  pnpmDeps = pkgs.fetchPnpmDeps {
    inherit (finalAttrs) pname version;
    pnpm = pkgs.pnpm;
    fetcherVersion = 5;
    src = "${finalAttrs.src}/ui";
    hash = "sha256-v8olAxZFEjMxUL33KfbFLjjO/uxcxHdLCIALDqRyjXs=";
  };
  nativeBuildInputs = [
    # Pull in our main hook
    cargo-tauri.hook

    # Setup npm
    nodejs
    pnpmConfigHook
    pkgs.pnpm # At least required by pnpmConfigHook, if not other (custom) phases
    # Make sure we can find our libraries
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ wrapGAppsHook4 ];

  postPatch = ''
    substituteInPlace src-tauri/tauri.conf.json \
      --replace-fail '"beforeBuildCommand": "pnpm build"' \
                        '"beforeBuildCommand": "cd ui && pnpm run build"'
  '';

  env = {
    RUSTY_V8_ARCHIVE = "${rustyV8Archive}";
    LINDERA_IPADIC_INPUT_FILE = "${linderaIpadicFile}";
  };

  buildInputs = with pkgs; [
    gtk3
    libayatana-appindicator
    dbus
    mpv
    librsvg
    openssl
    pkg-config
    glib-networking
    webkitgtk_4_1
    sqlite
  ];

  pname = "limusic";
  version = "1.4.0";


  # Set our Tauri source directory
  cargoRoot = "src-tauri";
  # And make sure we build there too
  buildAndTestSubdir = finalAttrs.cargoRoot;
})
