TERMUX_PKG_HOMEPAGE=https://github.com/ErikReider/SwayNotificationCenter
TERMUX_PKG_DESCRIPTION="A simple GTK based notification daemon for Sway"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.12.3
TERMUX_PKG_SRCURL=https://github.com/ErikReider/SwayNotificationCenter/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=788033f2d6c2599ec32809c875ec68f9affce062c8a0448fc50c062cdc08cd7f
TERMUX_PKG_DEPENDS="gtk4, libadwaita, glib, libgee, json-glib, dbus, libnotify"
TERMUX_PKG_BUILD_DEPENDS="valac, scdoc, sassc, gobject-introspection, blueprint-compiler"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dsystemd-service=false
"

termux_step_pre_configure() {
    termux_setup_meson
}

termux_step_post_make_install() {
    # Remove systemd service files if any were installed
    rm -rf "${TERMUX_PREFIX}/lib/systemd"
    rm -rf "${TERMUX_PREFIX}/share/systemd"
}
