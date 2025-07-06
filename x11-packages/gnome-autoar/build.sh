TERMUX_PKG_HOMEPAGE=https://github.com/GNOME/gnome-autoar
TERMUX_PKG_DESCRIPTION="gnome-autoar provides functions and widgets for GNOME applications"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.4.5
TERMUX_PKG_SRCURL=https://github.com/GNOME/gnome-autoar/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=179753f6f6454745aa2d404b1e7efcc20d6795f4a3a3b2cf2a8470b0b82e7e17
TERMUX_PKG_BUILD_DEPENDS="pkg-config, xorgproto, libxml2, libffi, libarchive"
TERMUX_PKG_DEPENDS="python, pygobject, gtk4, desktop-file-utils"
TERMUX_PKG_PYTHON_COMMON_DEPS="docutils"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_meson
}

termux_step_configure() {
	mkdir -p build
	$TERMUX_MESON setup build \
		--prefix="$TERMUX_PREFIX" \
		--buildtype=release \
		--cross-file="$TERMUX_MESON_CROSSFILE" \
		-Dintrospection=disabled \
		-Dgtk_doc=false \
		-Dtests=false
}

termux_step_make() {
	$TERMUX_MESON compile -C build
}

termux_step_make_install() {
	$TERMUX_MESON install -C build
}
