# FROM: https://github.com/bitcrushing/nixos-config/blob/main/pkgs/pipeasio/default.nix
{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  makeWrapper,
  wineWow64Packages,
  pipewire,
  qt6,
}:

let
  wine = wineWow64Packages.stagingFull;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "pipeasio";
  version = "unstable-2026-06-13";

  src = fetchFromGitHub {
    owner = "M0n7y5";
    repo = "pipeasio";
    rev = "679c4ac91f057b01427773a2018f1c65565cb87e";
    hash = "sha256-uGyAGTxRIC0MTlOT9WnJ81mVssEm8T8ETaQsu00Qh7U=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    makeWrapper
    wine
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    pipewire
    qt6.qtbase
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DBUILD_SETTINGS_PANEL=ON"
    "-DBUILD_TESTS=ON"
    "-DWINE_INCLUDE_DIRS=${wine}/include/wine;${wine}/include/wine/windows"
  ];

  # Run only the Linux-native unit tests in the sandbox.  The PipeWire
  # integration tests need a running daemon and the Wine tests need a
  # full Wine runtime, so they are built but not executed here.
  doCheck = true;
  checkPhase = ''
    runHook preCheck
    ctest -R 'test_(offsets|config)' --output-on-failure
    runHook postCheck
  '';

  postInstall = ''
    # Wrap the registration helper so it can find our Nix store install
    # and has a working wine on PATH.
    wrapProgram $out/bin/pipeasio-register \
      --prefix PATH : ${lib.makeBinPath [ wine ]} \
      --set-default PIPEASIO_PREFIX $out
  '';

  meta = {
    description = "ASIO to PipeWire driver for Wine";
    homepage = "https://github.com/M0n7y5/pipeasio";
    license = lib.licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
})
