{
  lib,
  fetchFromGitHub,
  rustPlatform,
  cmake,
  fontconfig,
  obs-studio,
  pkg-config,
}:
rustPlatform.buildRustPackage rec {
  pname = "obs-livesplit-one";
  version = "git";

  src = fetchFromGitHub {
    owner = "LiveSplit";
    repo = pname;
    rev = "b9c8489dd933c19c642375d73303436ba8d1a3cf";
    sha256 = lib.fakeHash;
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "livesplit-auto-splitting-0.1.0" = lib.fakeHash;
    };
  };

  nativeBuildInputs = [cmake pkg-config];
  buildInputs = [fontconfig obs-studio];

  postInstall = ''
    mkdir $out/lib/obs-plugins/
    mv $out/lib/libobs_livesplit_one.so $out/lib/obs-plugins/obs-livesplit-one.so
  '';

  meta = with lib; {
    description = "OBS Studio plugin for adding LiveSplit One as a source";
    homepage = "https://github.com/LiveSplit/obs-livesplit-one";
    license = with licenses; [asl20 mit];
    maintainers = [maintainers.Bauke];
    platforms = obs-studio.meta.platforms;
  };
}
