
{ lib
, pkgs
, qt5
}:

(lib.makeScope pkgs.newScope ( self:

let
  libsForQt5 = self;
  callPackage = self.callPackage;

  kdeFrameworks = let
    mkFrameworks = import ../development/libraries/kde-frameworks;
    attrs = {
      inherit libsForQt5;
      inherit (pkgs) lib fetchurl;
    };
  in (lib.makeOverridable mkFrameworks attrs);

  plasma5 = let
    mkPlasma5 = import ../desktops/plasma-5;
    attrs = {
      inherit libsForQt5;
      inherit (pkgs) lib fetchurl;
      gconf = pkgs.gnome2.GConf;
      inherit (pkgs) gsettings-desktop-schemas;
    };
  in (lib.makeOverridable mkPlasma5 attrs);

  kdeApplications = let
    mkApplications = import ../applications/kde;
    attrs = {
      inherit libsForQt5;
      inherit (pkgs) lib fetchurl;
      inherit (libsForQt5) okteta;
    };
  in (lib.makeOverridable mkApplications attrs);

in (kdeFrameworks // plasma5 // plasma5.thirdParty // kdeApplications // qt5 // {

  inherit kdeFrameworks plasma5 kdeApplications qt5;

  ### LIBRARIES

  accounts-qt = callPackage ../development/libraries/accounts-qt { };

  alkimia = callPackage ../development/libraries/alkimia { };

  appstream-qt = callPackage ../development/libraries/appstream/qt.nix { };

  dxflib = callPackage ../development/libraries/dxflib {};

  drumstick = callPackage ../development/libraries/drumstick { };

  fcitx-qt5 = callPackage ../tools/inputmethods/fcitx/fcitx-qt5.nix { };

  qgpgme = callPackage ../development/libraries/gpgme { };

  grantlee = callPackage ../development/libraries/grantlee/5 { };

  kdb = callPackage ../development/libraries/kdb { };

  kdiagram = callPackage ../development/libraries/kdiagram { };

  kdsoap = callPackage ../development/libraries/kdsoap { };

  kf5gpgmepp = callPackage ../development/libraries/kf5gpgmepp { };

  kproperty = callPackage ../development/libraries/kproperty { };

  kpeoplevcard = callPackage ../development/libraries/kpeoplevcard { };

  kreport = callPackage ../development/libraries/kreport { };

  ldutils = callPackage ../development/libraries/ldutils { };

  libcommuni = callPackage ../development/libraries/libcommuni { };

  libdbusmenu = callPackage ../development/libraries/libdbusmenu-qt/qt-5.5.nix { };

  libkeyfinder = callPackage ../development/libraries/libkeyfinder { };

  libktorrent = callPackage ../development/libraries/libktorrent { };

  liblastfm = callPackage ../development/libraries/liblastfm { };

  libopenshot = callPackage ../applications/video/openshot-qt/libopenshot.nix { };

  packagekit-qt = callPackage ../tools/package-management/packagekit/qt.nix { };

  libopenshot-audio = callPackage ../applications/video/openshot-qt/libopenshot-audio.nix { };

  libqglviewer = callPackage ../development/libraries/libqglviewer {
    inherit (pkgs.darwin.apple_sdk.frameworks) AGL;
  };

  libqtav = callPackage ../development/libraries/libqtav { };

  kpmcore = callPackage ../development/libraries/kpmcore { };

  mlt = callPackage ../development/libraries/mlt/qt-5.nix { };

  openbr = callPackage ../development/libraries/openbr { };

  phonon = callPackage ../development/libraries/phonon { };

  phonon-backend-gstreamer = callPackage ../development/libraries/phonon/backends/gstreamer.nix { };

  phonon-backend-vlc = callPackage ../development/libraries/phonon/backends/vlc.nix { };

  plasma-wayland-protocols = callPackage ../development/libraries/plasma-wayland-protocols { };

  polkit-qt = callPackage ../development/libraries/polkit-qt-1/qt-5.nix { };

  poppler = callPackage ../development/libraries/poppler {
    lcms = pkgs.lcms2;
    qt5Support = true;
    suffix = "qt5";
  };

  pulseaudio-qt = callPackage ../development/libraries/pulseaudio-qt { };

  qca-qt5 = callPackage ../development/libraries/qca-qt5 { };

  qmltermwidget = callPackage ../development/libraries/qmltermwidget {
    inherit (pkgs.darwin.apple_sdk.libs) utmp;
  };

  qmlbox2d = callPackage ../development/libraries/qmlbox2d { };

  qoauth = callPackage ../development/libraries/qoauth { };

  qscintilla = callPackage ../development/libraries/qscintilla {
    withQt5 = true;
  };

  qtutilities = callPackage ../development/libraries/qtutilities { };

  qtinstaller = callPackage ../development/libraries/qtinstaller { };

  qtkeychain = callPackage ../development/libraries/qtkeychain {
    withQt5 = true;
  };

  qtpbfimageplugin = callPackage ../development/libraries/qtpbfimageplugin { };

  qtstyleplugins = callPackage ../development/libraries/qtstyleplugins { };

  qtstyleplugin-kvantum = callPackage ../development/libraries/qtstyleplugin-kvantum { };

  quazip = callPackage ../development/libraries/quazip { };

  qwt = callPackage ../development/libraries/qwt/6.nix { };

  soqt = callPackage ../development/libraries/soqt { };

  telepathy = callPackage ../development/libraries/telepathy/qt { };

  qtwebkit-plugins = callPackage ../development/libraries/qtwebkit-plugins { };

})))
