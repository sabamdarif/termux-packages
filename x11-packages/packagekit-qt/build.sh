TERMUX_PKG_HOMEPAGE="https://www.freedesktop.org/software/PackageKit/"
TERMUX_PKG_DESCRIPTION="Qt bindings for PackageKit"
TERMUX_PKG_LICENSE="LGPL-2.1-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.1.4"
TERMUX_PKG_SRCURL="https://www.freedesktop.org/software/PackageKit/releases/PackageKit-Qt-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=5eae53721baec5ae2d52d97eee114d804cb769c922f9b5204d10ba70e82a17f3
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, packagekit, qt6-qtbase"

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR+="/PackageKit-Qt-$TERMUX_PKG_VERSION"
}
