TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/TheEvilSkeleton/Refine
TERMUX_PKG_DESCRIPTION="Tweak various aspects of GNOME"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="sabamdarif"
TERMUX_PKG_VERSION=0.5.10
TERMUX_PKG_SRCURL=https://gitlab.gnome.org/TheEvilSkeleton/Refine/-/archive/${TERMUX_PKG_VERSION}/Refine-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2ac6137878f09711219233269c60f9a1ee284c91c8c089ae2cb808cb5196d89c
TERMUX_PKG_DEPENDS="gobject-introspection, gtk4, libadwaita, pygobject, gsettings-desktop-schemas, python"
TERMUX_PKG_BUILD_DEPENDS="glib-cross"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dnetwork_tests=false
"

termux_step_pre_configure() {
	termux_setup_meson
	termux_setup_glib_cross_pkg_config_wrapper
}
