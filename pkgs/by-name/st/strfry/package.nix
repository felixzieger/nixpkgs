{
  lib,
  stdenv,
  fetchgit,
  gcc,
  perl,
  openssl,
  lmdb,
  flatbuffers,
  libuv,
  libnotify,
  callPackage,
  secp256k1,
  zlib-ng,
  git,
  zstd,
}:

let
  zstr = callPackage ./zstr.nix { };
in
stdenv.mkDerivation {
  pname = "strfry";
  version = "1.0.4";
  src = fetchgit {
    url = "https://github.com/hoytech/strfry.git";
    rev = "1.0.4";
    sha256 = "sha256-AcEALgq3q93gAYQ3RnhyMMqaO+XAn+GSOQp8qW+N+DE=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    gcc
    perl
    git
  ];

  buildInputs = [
    openssl
    lmdb
    flatbuffers
    libuv
    libnotify
    zstr
    secp256k1
    zlib-ng
    zstd
  ];

  makeFlags = [ "-j$NIX_BUILD_CORES" ];

  prePatch = ''
    # I could not get submodule commands from golpe to work with fetchGit,
    # so I'm initializing a new git repo here.
    rm -rf .git
    git init
    git config --local user.email "nixbuild@example.com"
    git config --local user.name "Nix Builder"
    git add .
    git commit -m "Initial commit"
  '';

  buildPhase = ''
    # Patch shebangs in Perl scripts
    patchShebangs golpe/

    # Now run the build commands
    make -j$NIX_BUILD_CORES
  '';

  installPhase = ''
    mkdir -p $out/bin
    pwd
    ls -l .
    cp ./strfry $out/bin/
  '';

  meta = with lib; {
    description = "Strfry: A nostr relay implementation in C++";
    homepage = "https://github.com/hoytech/strfry";
    license = licenses.mit;
    maintainers = with maintainers; [ felixzieger ];
    platforms = platforms.unix;
  };
}
