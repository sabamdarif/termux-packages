TERMUX_PKG_HOMEPAGE=https://kde.org/plasma-desktop/
TERMUX_PKG_DESCRIPTION="KDE Plasma Workspace"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.4.4"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/plasma-workspace-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=de53b4eef688b59b7c56090485d41e7f8be3d3b99f1cf1358a7d3f4da9eebcb2
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, dbus, fontconfig, freetype, libicu, kactivitymanagerd, kf6-karchive, kf6-kauth, kf6-kbookmarks, kf6-kcmutils, kf6-kcompletion, kf6-kconfig, kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kcrash, kf6-kdbusaddons, kf6-kdeclarative, kf6-kglobalaccel, kf6-kguiaddons, kf6-kholidays, kf6-ki18n, kf6-kiconthemes, kf6-kio, kf6-kirigami, kf6-kirigami-addons, kf6-kitemmodels, kf6-kjobwidgets, kf6-knewstuff, kf6-knotifications, kf6-knotifyconfig, kf6-kpackage, kf6-krunner, kf6-kservice, kf6-kstatusnotifieritem, kf6-ksvg, kf6-ktexteditor, kf6-ktextwidgets, kf6-kunitconversion, kf6-kuserfeedback, kf6-kwallet, kf6-kwidgetsaddons, kwin-x11, kf6-kwindowsystem, kf6-kxmlgui, libcanberra, libcrypt, libice, libplasma, qalc, libsm, libx11, libxau, libxcb, libxcursor, libxfixes, libxft, libxtst, milou, ocean-sound-theme, plasma-activities, plasma-activities-stats, plasma5support, kf6-prison, qt6-qt5compat, qt6-qtbase, qt6-qtdeclarative, qt6-qtlocation, qt6-qttools, kf6-solid, xcb-util, xcb-util-cursor, xcb-util-image, xorg-xmessage, xorg-xrdb, zlib"
TERMUX_PKG_BUILD_DEPENDS="kf6-baloo, extra-cmake-modules, phonon-qt6, qcoro"
TERMUX_PKG_RECOMMENDS="plasma-workspace-wallpapers"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
"
