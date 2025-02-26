{
  lib,
  stdenv,
  fetchFromGitHub,
  zlib,
}:

stdenv.mkDerivation {
  pname = "zstr";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "mateidavid";
    repo = "zstr";
    rev = "v1.0.7";
    sha256 = "sha256-NVwfzDraZKn6CUjHctc03uokvvozxF5h8YbKS0BkyTI=";
  };

  buildInputs = [ zlib ];

  installPhase = ''
    mkdir -p $out/include
    cp src/strict_fstream.hpp src/zstr.hpp $out/include/
  '';

  meta = with lib; {
    description = "C++ header-only library for reading/writing compressed streams";
    homepage = "https://github.com/mateidavid/zstr";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
