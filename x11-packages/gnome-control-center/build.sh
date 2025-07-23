TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/gnome-control-center
TERMUX_PKG_DESCRIPTION="Gnome settings app"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="48.1"
TERMUX_PKG_SRCURL=https://github.com/GNOME/gnome-control-center/archive/refs/tags/${TERMUX_PKG_VERSION}.zip
TERMUX_PKG_SHA256=deb847b6239b26d321bf677300563be15e72ffff58dc84e3327ebafdd283d477
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, libglibmm-2.68, libcanberra, gtk4, libadwaita, gobject-introspection, pulseaudio, gettext, accountsservice, gdk-pixbuf, gnome-desktop4, gsettings-desktop-schemas, gnome-settings-daemon, libxml2, upower, gcr4, fontconfig, cups, polkit, krb5, ibus, gsound, samba, libsecret"
TERMUX_PKG_BUILD_DEPENDS="glib-cross, glib, libwayland, libepoxy, libwayland-protocols, mutter, libwayland-cross-scanner, libx11, libxi, libgtop, libcairo, libandroid-glob"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dlocation-services=disabled
-Dsnap=false
-Dtests=false
-Dx11=true
-Ddocumentation=false
"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
	termux_setup_meson
	termux_setup_glib_cross_pkg_config_wrapper
	termux_setup_pkg_config_wrapper "${TERMUX_PREFIX}/opt/glib/cross/lib/x86_64-linux-gnu/pkgconfig:${TERMUX_PREFIX}/opt/libwayland/cross/lib/x86_64-linux-gnu/pkgconfig"
}

termux_step_post_get_source() {
	rm -rf $TERMUX_PKG_SRCDIR/subprojects/gvc
	git clone https://gitlab.gnome.org/GNOME/libgnome-volume-control $TERMUX_PKG_SRCDIR/subprojects/gvc
}
