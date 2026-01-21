TERMUX_PKG_HOMEPAGE=https://github.com/wmww/gtk4-layer-shell
TERMUX_PKG_DESCRIPTION="Library to create panels and other desktop components for Wayland using the Layer Shell protocol and GTK4"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.0"
TERMUX_PKG_SRCURL=https://github.com/wmww/gtk4-layer-shell/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1ebb01ab14e98afd1727f68f64981c37bd23305b1f131f5667c02b94cf593192
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="glib, gtk4, libwayland"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, libwayland-cross-scanner, libwayland-protocols"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Ddocs=false
-Dintrospection=true
-Dtests=false
-Dvapi=true
-Dexamples=false
-Dsmoke-tests=false
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_wayland_cross_pkg_config_wrapper
}
