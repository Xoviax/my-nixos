{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, gtk4
, gtk4-layer-shell
}:

rustPlatform.buildRustPackage rec {
  pname = "omarchy-screenshot-preview";
  version = "master";

  src = fetchFromGitHub {
    owner = "rodrigo-sntg";
    repo = "omarchy-screenshot-preview";
    rev = "62b5216315a989c888a4b367029465debb4ad224";
    hash = "sha256-MPO1lerULNFHVP2PBQXCKcyikNVm+OmZ4NbS+l0sM70=";
  };

  cargoHash = lib.fakeHash;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    gtk4
    gtk4-layer-shell
  ];

  meta = with lib; {
    description = "macOS-style screenshot preview with drag-and-drop for Wayland/Hyprland";
    homepage = "https://github.com/rodrigo-sntg/omarchy-screenshot-preview";
    license = licenses.mit;
    mainProgram = "omarchy-screenshot-preview";
  };
}
