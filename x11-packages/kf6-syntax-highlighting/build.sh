TERMUX_PKG_HOMEPAGE=https://community.kde.org/Frameworks
TERMUX_PKG_DESCRIPTION="Syntax highlighting Engine for Structured Text and Code"
TERMUX_PKG_LICENSE="GPL-2.0-only, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.18.0"
TERMUX_PKG_SRCURL=https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/syntax-highlighting-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=8be8057221a982c8d1fe42f95454fac9610eb51975226c6652689293cd335bfd
TERMUX_PKG_DEPENDS="libc++, opengl, qt6-qtdeclarative, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="aosp-libs, extra-cmake-modules, qt6-qttools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		return
	fi

	# for cross-compiling, it's easiest to just use termux-proot-run to run the katehighlightingindexer
	termux_setup_proot
	mkdir -p "$TERMUX_PKG_TMPDIR/bin"
	cat > "$TERMUX_PKG_TMPDIR/bin/katehighlightingindexer" <<-HERE
		#!$(command -v bash)
		exec $(command -v termux-proot-run) env LD_PRELOAD= LD_LIBRARY_PATH= $TERMUX_PKG_BUILDDIR/bin/katehighlightingindexer "\$@"
	HERE
	chmod +x "$TERMUX_PKG_TMPDIR/bin/katehighlightingindexer"
	PATH="$TERMUX_PKG_TMPDIR/bin:$PATH"
}
