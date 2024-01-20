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
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "LiveSplit";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-3B3P1PlzIlpVqHJMKWpEnWXGgD/IaiWM1FVKn0BtRj0=";
  };

  postPatch = ''
    ls -lah
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  cargoLock = {
    lockFile = ./Cargo.lock;
  };
  # cargoHash = "sha256-mQ0TR4DL4bA5u4IL3RY9aLxU5G6qQ5W5xuNadiXGeB0=";

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
