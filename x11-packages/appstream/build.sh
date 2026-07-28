TERMUX_PKG_HOMEPAGE="https://www.freedesktop.org/wiki/Distributions/AppStream/"
TERMUX_PKG_DESCRIPTION="Provides a standard for creating app stores across distributions"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.1.5"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/ximion/appstream/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2160a8d9205448214a9e3c9fe3bc205fa630542109c8bf869b26951989b9bb38
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="curl, fontconfig, freetype, gdk-pixbuf, glib, libcairo, libfyaml, librsvg, libxml2, libxmlb, pango, zstd"
TERMUX_PKG_BUILD_DEPENDS="bash-completion, g-ir-scanner, glib-cross, libwayland, valac, qt6-qtbase, qt6-qttools, qt6-qttools-cross-tools"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dapidocs=false
-Ddocs=false
-Dgir=true
-Dstemming=false
-Dsystemd=false
-Dvapi=true
-Dqt=true
-Dcompose=true
-Dblake3-support=false
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
}

termux_step_configure() {
	termux_setup_meson

	# This is how to cross-compile Qt6 packages that use the Meson build system
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		local TERMUX_MESON_QT_CROSSFILE="$TERMUX_PKG_TMPDIR/qt-cross-file.txt"
		cp -f "$TERMUX_MESON_CROSSFILE" "$TERMUX_MESON_QT_CROSSFILE"
		local qt6_tool
		for qt6_tool in bin/lrelease moc uic qmltyperegistrar qmlcachegen rcc; do
			sed -i "s|^\(\[binaries\]\)$|\1\n${TERMUX_PREFIX}/lib/qt6/${qt6_tool} = '${TERMUX_PREFIX}/opt/qt6/cross/lib/qt6/${qt6_tool}'|g" \
				"$TERMUX_MESON_QT_CROSSFILE"
		done
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --cross-file $TERMUX_MESON_QT_CROSSFILE"
	fi

	termux_step_configure_meson
}

termux_step_post_make_install() {
	# needed by discover
	# ninja: error: '/data/data/com.termux/files/usr/lib/libAppStreamQt.so.1.1.1',
	# needed by 'bin/libDiscoverCommon.so', missing and no known rule to make it
	ln -sf "$TERMUX_PREFIX"/lib/libAppStreamQt.so{,".$TERMUX_PKG_VERSION"}
}

termux_step_create_debscripts() {
	# based on https://salsa.debian.org/pkgutopia-team/appstream/-/blob/f7fa648984bc967611aa903c614067a93e1b73fa/debian/appstream.postinst
	cat <<-EOF >postinst
		#!$TERMUX_PREFIX/bin/sh
		set -e

		if [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ]; then
			exit 0
		fi

		if [ "\$1" = "triggered" ]; then
			# Only update caches for OS resources on trigger, and also
			# do not force an update so this only runs when necessary
			appstreamcli refresh-cache --source=os || true
			exit 0
		fi

		# Force-upgrade the cache, to ensure it matches the installed
		# version of AppStream and is present.
		appstreamcli refresh-cache --force || true
	EOF
}
