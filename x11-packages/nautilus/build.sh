TERMUX_PKG_HOMEPAGE=https://github.com/GNOME/nautilus
TERMUX_PKG_DESCRIPTION="The GNOME File Manager"
TERMUX_PKG_LICENSE="GPL-3.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=48.1
TERMUX_PKG_SRCURL=https://github.com/GNOME/nautilus/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=cbc7baf4965000ef5c673f389db3c9f42386961eefc9e5fa8896e88eba843ff9
TERMUX_PKG_DEPENDS="dbus, glib, gstreamer, totem-pl-parser, libportal, libportal-gtk4, gdk-pixbuf, gnome-autoar, gnome-desktop4, libadwaita"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, gst-plugins-base, glib-cross"
TERMUX_PKG_PYTHON_COMMON_DEPS="setuptools, docutils"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Ddocs=false
-Dcloudproviders=false
-Dpackagekit=false
-Dselinux=false
-Dtests=none
"

termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_meson
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
	export TERMUX_MESON_ENABLE_SOVERSION=1
}
