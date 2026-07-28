TERMUX_PKG_HOMEPAGE="https://apps.kde.org/discover/"
TERMUX_PKG_DESCRIPTION="KDE Plasma resources management GUI that helps you find and install applications, games, and tools"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.7.3"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/discover-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=f28c47569ddffd95c1095ea6c73cfe01a6943bbb3be5d8158d5431c443439f1c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="appstream-qt, discount, glib, kf6-attica, kf6-karchive, kf6-kcmutils, kf6-kconfig, kf6-kcoreaddons, kf6-kcrash, kf6-kdbusaddons, kf6-ki18n, kf6-kiconthemes, kf6-kidletime, kf6-kio, kf6-kirigami, kf6-kjobwidgets, kf6-knewstuff, kf6-knotifications, kf6-kservice, kf6-kstatusnotifieritem, kf6-kuserfeedback, kf6-kwidgetsaddons, kf6-kwindowsystem, kf6-kxmlgui, kf6-purpose, kf6-qqc2-desktop-style, kirigami-addons, libc++, packagekit-qt, qcoro, qt6-qtbase, qt6-qtdeclarative, qt6-qtwebview, termux-appstream-data "
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qcoro-static"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DKF6_HOST_TOOLING=$TERMUX_PREFIX/opt/kf6/cross/lib/cmake/"
	fi

	LDFLAGS+=" -Wl,-rpath=$TERMUX_PREFIX/lib/plasma-discover"
}
