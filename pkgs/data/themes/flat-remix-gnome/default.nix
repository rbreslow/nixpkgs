{ stdenv
, fetchFromGitHub
, glib
, lib
, writeScriptBin
}:
let
  # make install will use dconf to find desktop background file uri.
  # consider adding an args to allow specify pictures manually.
  # https://github.com/daniruiz/flat-remix-gnome/blob/20220407/Makefile#L38
  fake-dconf = writeScriptBin "dconf" "echo -n";
in
stdenv.mkDerivation rec {
  pname = "flat-remix-gnome";
  version = "20220407";

  src = fetchFromGitHub {
    owner = "daniruiz";
    repo = pname;
    rev = version;
    hash = "sha256-Q54uF49NbvupN6LH80bgRtvyW7Cqm9vqsWXDkQrF4HQ=";
  };

  nativeBuildInputs = [ glib fake-dconf ];
  makeFlags = [ "PREFIX=$(out)" ];
  preInstall = ''
    # make install will back up this file, it will fail if the file doesn't exist.
    # https://github.com/daniruiz/flat-remix-gnome/blob/20220407/Makefile#L56
    mkdir -p $out/share/gnome-shell/
    touch $out/share/gnome-shell/gnome-shell-theme.gresource
  '';

  postInstall = ''
    rm $out/share/gnome-shell/gnome-shell-theme.gresource.old
  '';

  meta = with lib; {
    description = "GNOME Shell theme inspired by material design.";
    homepage = "https://drasite.com/flat-remix-gnome";
    license = licenses.cc-by-sa-40;
    platforms = platforms.linux;
    maintainers = [ maintainers.vanilla ];
  };
}
