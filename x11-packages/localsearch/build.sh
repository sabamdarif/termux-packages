TERMUX_PKG_HOMEPAGE=https://github.com/GNOME/localsearch
TERMUX_PKG_DESCRIPTION="Local search library that uses Tracker"
TERMUX_PKG_LICENSE="LGPL-2.1-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.9.0
TERMUX_PKG_SRCURL=https://github.com/GNOME/localsearch/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6d8d5ff2a2320632e2cd14ef5a9c6a57d67430ac71d36428a257404a81dcf943
TERMUX_PKG_DEPENDS="asciidoc, dbus, glib, sqlite, gstreamer, upower, totem-pl-parser, libexif, gexiv2, libgxps, libseccomp, libpng, ffmpeg, libportal, libportal-gtk3, libportal-gtk4"
TERMUX_PKG_BUILD_DEPENDS="libseccomp, asciidoc, gettext"
TERMUX_PKG_PYTHON_COMMON_DEPS="jinja2, markupsafe, markdown, pygments, typogrify, docutils"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dsystemd_user_services=false
-Dlandlock=disabled
"
termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_meson
	export TERMUX_MESON_ENABLE_SOVERSION=1
}

termux_step_post_make_install() {
    rm -rf $TERMUX_PREFIX/lib/python*/site-packages/asciidoc
}
