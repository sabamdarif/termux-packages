TERMUX_PKG_HOMEPAGE="https://www.freedesktop.org/software/PackageKit/"
TERMUX_PKG_DESCRIPTION="System designed to make installing and updating software easier"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.6"
TERMUX_PKG_SRCURL="https://www.freedesktop.org/software/PackageKit/releases/PackageKit-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=a3458173efd3c3d0e2d049b95be26300f37c96219314164da2bd6778546a3d51
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="dbus, glib, gobject-introspection, gst-plugins-base, libandroid-glob, libsqlite, libjansson"
TERMUX_PKG_SUGGESTS="bash-completion"
TERMUX_PKG_BUILD_DEPENDS="apt, pacman, bash-completion"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
# just basic features enabled to start with; enable more features if needed
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dpackaging_backend=${TERMUX_PACKAGE_MANAGER//pacman/alpm}
-Dsysconfdir=$TERMUX_PREFIX/etc
-Dgobject_introspection=true
-Dman_pages=true
-Dbash_completion=true
-Dbash_command_not_found=true
-Dgstreamer_plugin=true
-Ddaemon_tests=false
-Dsystemd=false
-Doffline_update=false
-Dgtk_doc=false
-Dgtk_module=false
-Dcron=false
-Dpython_backend=false
"
TERMUX_PKG_SERVICE_SCRIPT=(
	"packagekitd"
	"exec \"$TERMUX_PREFIX/libexec/packagekitd\" --disable-timer 2>&1"
)

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper

	LDFLAGS+=" -landroid-glob"

	find "$TERMUX_PKG_SRCDIR" -type f -print0 |
		xargs -0 sed -i \
			-e "s|/tmp|$TERMUX_PREFIX/tmp|g"
}
