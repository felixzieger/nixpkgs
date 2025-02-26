{
  lib,
  stdenv,
  fetchFromGitHub,
  gcc,
  perl,
  openssl,
  lmdb,
  flatbuffers,
  libuv,
  libnotify,
  secp256k1,
  zlib-ng,
  git,
  zstd,
}:
stdenv.mkDerivation {
  pname = "strfry";
  version = "1.0.4";
  src = fetchFromGitHub {
    owner = "hoytech";
    repo = "strfry";
    rev = "1.0.4";
    sha256 = "sha256-2+kPUgyb9ZtC51EK66d3SX2zyqnS6lju2jkIhakcudg=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    gcc
    perl
    git
  ];

  buildInputs = [
    openssl # libssl-dev
    lmdb # liblmdb-dev
    flatbuffers # libflatbuffers-dev
    libuv # libuv1-dev
    libnotify # libnotify-dev
    secp256k1 # libsecp256k1-dev
    zlib-ng # alternative to zlib1g-dev
    zstd # libzstd-dev
  ];

  makeFlags = [ "-j$NIX_BUILD_CORES" ];

  # golpe initializes a git repo which doesn't work with the one fetched by fetchgit,
  # so I'm initializing a new git repo here.
  prePatch = ''
    rm -rf .git
    git init
    git config --local user.email "nixbuild@example.com"
    git config --local user.name "Nix Builder"
    git add .
    git commit -m "Initial commit"
  '';

  buildPhase = ''
    patchShebangs golpe/
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
