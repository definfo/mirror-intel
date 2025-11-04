{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  version ? null,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mirror-intel";
  inherit version;

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.intersection (lib.fileset.fromSource (lib.sources.cleanSource ./.)) (
      lib.fileset.unions [
        ./src
        ./tests
        ./Cargo.lock
        ./Cargo.toml
        ./LICENSE
        ./Rocket.toml
      ]
    );
  };

  cargoHash = "sha256-RQPpa+ntnHdWI5xvzqckfIbdg+2NTWWZl8XsHA7ieCQ=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
  ];

  env.OPENSSL_NO_VENDOR = 1;

  buildInputs = [
    openssl
  ];

  meta = {
    description = "Intelligent mirror redirector middleware for SJTUG";
    homepage = "https://github.com/sjtug/mirror-intel";
    license = with lib.licenses; [ asl20 ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ definfo ];
  };
})
