TERMUX_PKG_HOMEPAGE=https://github.com/pantor/inja
TERMUX_PKG_DESCRIPTION="A template engine for modern C++"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.5.0"
TERMUX_PKG_SRCURL=https://github.com/pantor/inja/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a5f0266673c59028eab6ceeddd8b862c70abfeb32fb7a5387c16bf46f3269ab2
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="nlohmann-json"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Dbuild_tests=false"

termux_step_configure() {
	termux_step_configure_meson
}
