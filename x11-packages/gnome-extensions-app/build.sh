TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/gnome-shell
TERMUX_PKG_DESCRIPTION="GNOME Extensions app"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=48.1
TERMUX_PKG_SRCURL=https://github.com/GNOME/gnome-shell/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d316bf1d3872282b813eab70a73c04a7431c8036f34e102607bf691004d3fa79
TERMUX_PKG_BUILD_DEPENDS="pkg-config, xorgproto, libxml2, libffi, gjs, g-ir-scanner, gettext"
TERMUX_PKG_DEPENDS="python, pygobject, gtk4, desktop-file-utils"
TERMUX_PKG_PYTHON_COMMON_DEPS="setuptools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_meson
}

termux_step_configure() {
	cd $TERMUX_PKG_SRCDIR/subprojects/extensions-app
	mkdir -p build
	$TERMUX_MESON setup build \
		--prefix="$TERMUX_PREFIX" \
		--buildtype=release \
		--cross-file="$TERMUX_MESON_CROSSFILE"
}

termux_step_make() {
	meson compile -C build
}

termux_step_make_install() {
	meson install -C build
}
