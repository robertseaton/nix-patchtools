with import <nixpkgs> {};

let
  autopatchelf = import ../default.nix;
in
stdenv.mkDerivation {
  name = "pixelator";
  src = ~/downloads/pixelator-1.0.5-linux-x64.zip;
  nativeBuildInputs = [
    libudev0-shim
    udev
    dpkg
    autopatchelf
    unzip
    zlib
    harfbuzz
    freetype
    makeWrapper 
];
  libs = stdenv.lib.makeLibraryPath [
    glibc
    libgcc
    gcc-unwrapped
    gtk2-x11
    zlib
    gnome2.pango
    atk
    cairo
    gdk_pixbuf
    glib
    fontconfig
    freetype
    dbus_daemon.lib
    dbus.lib
    xlibs.libX11
    xlibs.libxcb
    xlibs.libXi
    xlibs.libXcursor
    xlibs.libXdamage
    xlibs.libXrandr
    xlibs.libXcomposite
    xlibs.libXext
    nix
    xlibs.libXfixes
    xlibs.libXrender
    xlibs.libXtst
    xlibs.libXScrnSaver
    gnome2.GConf.out
    nss.out
    alsaLib.out
    nspr.out
    cups.lib
    xorg_sys_opengl.out
    expat.out
    harfbuzz.out
    libudev0-shim
];
  installPhase = ''
    chmod +xX pixelator
    chmod +xX _pixelator_cmd.exe
    mkdir -p $out/bin
    mv * $out
    autopatchelf $out

    ln -s $out/pixelator $out/bin/pixelator
    ln -s $out/_pixelator_cmd.exe $out/bin/_pixelator_cmd.exe
  '';
  preFixup = let
    runtimeLibs = lib.makeLibraryPath [ libudev0-shim ];
  in ''
  wrapProgram "$out/pixelator" --prefix LD_LIBRARY_PATH : ${runtimeLibs}
  '';
  dontStrip = true;
}
