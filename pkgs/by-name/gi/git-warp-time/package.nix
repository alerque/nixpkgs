{
  lib,
  stdenv,
  fetchzip,

  # nativeBuildInputs
  pkg-config,
  jq,
  cargo,
  rustc,
  rustPlatform,

  # buildInputs
  libgit2,
  typos,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "git-warp-time";
  version = "0.8.4";

  src = fetchzip {
    url = "https://github.com/alerque/git-warp-time/releases/download/v${finalAttrs.version}/git-warp-time-${finalAttrs.version}.zip";
    sha256 = "sha256-PPb1GEg8rQC2FCYbKhodKs5lWmp7mqMcbsbkLeqk9ok=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) src;
    dontConfigure = true;
    hash = "sha256-ozy8Mfl5fTJL2Sr22tCSnK30SOKaC9cL+g4lX6ivi9Q=";
  };

  nativeBuildInputs = [
    pkg-config
    jq
    cargo
    rustc
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    libgit2
    typos
  ];

  env = {
    LIBGIT2_NO_VENDOR = "1";
  };

  outputs = [
    "out"
    "doc"
    "man"
    "dev"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Utility to reset filesystem timestamps based on Git history";
    longDescription = ''
      A CLI utility that resets the timestamps of files in a Git repository
      working directory to the exact timestamp of the last commit which
      modified each file.
    '';
    homepage = "https://github.com/alerque/git-warp-time";
    changelog = "https://github.com/alerque/git-warp-time/raw/v${finalAttrs.version}/CHANGELOG.md";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      alerque
    ];
    license = lib.licenses.gpl3Only;
    mainProgram = "git-warp-time";
  };
})
