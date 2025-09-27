TERMUX_PKG_HOMEPAGE=https://kde.org/plasma-desktop/
TERMUX_PKG_DESCRIPTION="Easy to use, but flexible, X Window Manager"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.4.4"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/kwin-x11-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=987e207c2f2ab60e51421b5846ca03e69ef875ac20698022f5e8bdd1e1055ed9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, aurorae, kf6-kauth, kf6-kcmutils, kf6-kcolorscheme, kf6-kconfig, kf6-kcoreaddons, kf6-kcrash, kf6-kdeclarative, kdecoration, kf6-kglobalaccel, kglobalacceld, kf6-kguiaddons, kf6-ki18n, kf6-kiconthemes, kf6-kirigami, kf6-kitemmodels, kf6-knewstuff, kf6-knotifications, kf6-kpackage, kf6-kservice, kf6-ksvg, kf6-kwidgetsaddons, kf6-kwindowsystem, kf6-kxmlgui, littlecms, libandroid-shmem, libcanberra, libdisplay-info, libdrm, libepoxy, libqaccessibilityclient-qt6, libx11, libxcb, libxi, libxkbcommon, opengl, libplasma, qt6-qt5compat, qt6-qtbase, qt6-qtdeclarative, qt6-qtsensors, qt6-qtsvg, qt6-qttools, xcb-util-cursor, xcb-util-keysyms, xcb-util-wm"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qtbase-cross-tools, kf6-kconfig-cross-tools, kf6-kpackage-cross-tools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKWIN_BUILD_SCREENLOCKER=OFF
"

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DKF6_HOST_TOOLING=$TERMUX_PREFIX/lib/cmake"
	else
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DKF6_HOST_TOOLING=$TERMUX_PREFIX/opt/kf6/cross/lib/cmake"
	fi

	LDFLAGS+=" -landroid-shmem"
}
